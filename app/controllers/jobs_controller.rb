require 'rubygems'
require 'zip/zipfilesystem'

class JobsController < ApplicationController
  unloadable
  before_filter :require_admin, :except => [:index, :show, :register]
  #before_filter :authorize
  
  helper :attachments
  include AttachmentsHelper
  helper :custom_fields
  include CustomFieldsHelper
  helper :sort
  include SortHelper
  
  default_search_scope :jobs

  # GET /jobs
  # GET jobs_url
  def index
    sort_init 'submission_date', 'desc'
    sort_update %w(title category short_desc status submission_date)
    
    # secure the parent apptracker id and find its jobs
    @apptracker = Apptracker.find(params[:apptracker_id])
    if(User.current.admin?)
      @jobs = @apptracker.jobs.find(:all, :order => sort_clause)
    else
      @jobs = @apptracker.jobs.find(:all, :conditions => ["status = ? and submission_date > ?", Job::JOB_STATUS[0], DateTime.now], :order => sort_clause)
    end
  end
  
  # GET /jobs/1
  # GET job_url(:id => 1)
  def show
    # secure the parent apptracker id and find requested job
    @apptracker = Apptracker.find(params[:apptracker_id])
    @job = @apptracker.jobs.find(params[:id])
    @zipped_file = params[:zipped_file]
    
    session[:auth_source_registration] = nil
    @user = User.new(:language => Setting.default_language)
    
    sort_init 'created_at', 'desc'
    sort_update 'last_name' => "#{Applicant.table_name}.last_name",
                'id' => "#{JobApplication.table_name}.id",
                'submission_status' => "#{JobApplication.table_name}.submission_status",
                'acceptance_status' => "#{JobApplication.table_name}.acceptance_status",
                'created_at' => "#{JobApplication.table_name}.created_at"
    #sort_update %w(id submission_status, acceptance_status, created_at)
    @job_applications = @job.job_applications.find(:all, :order => sort_clause)
    
    @job_attachments = @job.job_attachments.build
    job_attachments = @job.job_attachments.find :first, :include => [:attachments]
    @job_attachment = job_attachments
    
    @job_application_custom_fields = @job.all_job_app_custom_fields
    
    respond_to do |format|
      format.html #show.html.erb
    end
  end

  # GET /jobs/new
  # Get new_job_url
  def new
    # secure the parent apptracker id and create a new job
    @apptracker = Apptracker.find(params[:apptracker_id])
    
    if(params[:job_id].nil?)
      @job = @apptracker.jobs.new
    else
      @job = @apptracker.jobs.find(params[:job_id])
    end
    respond_to do |format|
        format.html # new.html.erb
    end
  end
  
  # POST /jobs
  # POST jobs_url
  def create
    # create a job in its parent apptracker
    @apptracker = Apptracker.find(params[:job][:apptracker_id])
    @job = @apptracker.jobs.new(params[:job])    
    unless params[:application_material_types].nil?
      @job.application_material_types = params[:application_material_types].join(",") + "," + params[:other_app_materials]
    else
      @job.application_material_types = params[:other_app_materials]  
    end  
    
    respond_to do |format|
      if(@job.save)
        
        #if job saved then create the job attachments
        #@job_attachments = params[:job][:job_attachments_attributes]["0"]
        job_file = Hash.new
        job_file["job_id"] = @job.id
        job_file["name"] = @job.title
        job_file["filename"] = @job.title
        job_file["notes"] = @job.title
        @job_attachment = @job.job_attachments.build(job_file)
        @job_attachment.save
        attachments = Attachment.attach_files(@job_attachment, params[:attachments])
        render_attachment_warning_if_needed(@job_attachment)
        
        flash[:notice] = l(:notice_successful_create)
        
        # no errors, redirect to second part of form
        format.html { redirect_to(jobs_url(:apptracker_id => @apptracker.id)) }
      else
        # validation prevented save; redirect back to new.html.erb with error messages
        format.html { render :action => "new" }
      end
    end
  end

  # GET /jobs/1/edit
  # GET edit_job_url(:id => 1)
  def edit
    # secure the parent apptracker id and find the job to edit
    @apptracker = Apptracker.find(params[:apptracker_id])
    @job = @apptracker.jobs.find(params[:id])
    @job_attachment = @job.job_attachments.find :first, :include => [:attachments]

    @custom_field = begin
      "JobApplicationCustomField".to_s.constantize.new(params[:custom_field])
    rescue
    end
    
    @job_application_custom_fields = JobApplicationCustomField.find(:all, :order => "#{CustomField.table_name}.position")
    
  end

  # PUT /jobs/1
  # PUT job_url(:id => 1)
  def update
    # find the job within its parent apptracker
    @apptracker = Apptracker.find(params[:job][:apptracker_id])
    @job = @apptracker.jobs.find(params[:id])
    # update the job's attributes, and indicate a message to the user opon success/failure
    respond_to do |format|
      if(@job.update_attributes(params[:job]))
        unless params[:application_material_types].nil?
          @job.application_material_types = params[:application_material_types].join(",") + "," + params[:other_app_materials]
        else
          @job.application_material_types = params[:other_app_materials]  
        end
        @job.save
        # no errors, redirect with success message
        @job_attachment = JobAttachment.find(:first, :conditions => {:job_id => @job.id})
        job_file = Hash.new
        job_file["job_id"] = @job.id
        job_file["name"] = @job.title
        job_file["filename"] = @job.title
        job_file["notes"] = @job.title
        @job_attachment.update_attributes(job_file)
        attachments = Attachment.attach_files(@job_attachment, params[:attachments])
        render_attachment_warning_if_needed(@job_attachment)
        
        format.html { redirect_to(edit_job_url(@job, :apptracker_id => @apptracker.id), :notice => "\'#{@job.title}\' has been updated.") }
      else
        # validation prevented update; redirect to edit form with error messages
        @job_attachment = @job.job_attachments.find :first, :include => [:attachments]
        @custom_field = begin
          "JobApplicationCustomField".to_s.constantize.new(params[:custom_field])
        rescue
        end
        @job_application_custom_fields = JobApplicationCustomField.find(:all, :order => "#{CustomField.table_name}.position")
        format.html { render :action => "edit"}
      end
    end
  end

  # DELETE /jobs/1
  # DELETE job_url(:id => 1)
  def destroy
    # create a job in its parent apptracker
    @apptracker = Apptracker.find(params[:apptracker_id])
    @job = @apptracker.jobs.find(params[:id])

    # destroy the job, and indicate a message to the user upon success/failure
    @job.destroy ? flash[:notice] = "\'#{@job.title}\' has been deleted." : flash[:error] = "Error: \'#{@job.title}\' could not be deleted."
    
    respond_to do |format|
      format.html { redirect_to(jobs_url(:apptracker_id => @apptracker.id)) }
    end
  end
  
  def create_custom_field
    custom_field = CustomField.new(params[:custom_field])
    custom_field.type = params[:type]
    custom_field = begin
      if params[:type].to_s.match(/.+CustomField$/)
        params[:type].to_s.constantize.new(params[:custom_field])
      end
    rescue
    end
    job = Job.find_by_id params[:id]
    
    if custom_field.save
      flash[:notice] = l(:notice_successful_create)
      call_hook(:controller_custom_fields_new_after_save, :params => params, :custom_field => custom_field)
      cf_ids = job.all_job_app_custom_fields.collect {|cfield| cfield.id }
      cf_ids << custom_field.id
      cf = {"job_application_custom_field_ids" => cf_ids}
      job.attributes = cf
      job.save
    else
      flash[:notice] = "Custom field could not be added."
    end
    
    redirect_to :action => "edit", :id => job, :apptracker_id => job.apptracker_id
  end

  # Removes a CustomField from an Job.
  #
  # @return Nothing.
  def remove_custom_field
    job = Job.find_by_id params[:id]
    custom_field = JobApplicationCustomField.find_by_id params[:existing_custom_field]
    job.job_application_custom_fields.delete custom_field
    job.save
    redirect_to :action => "edit", :id => job, :apptracker_id => job.apptracker_id
  end
  
  def zip_all
    @job = Job.find(params[:job])
    @material_types = @job.application_material_types.split(',')
    @file_name = @job.title.gsub(/ /, '-')
    @zip_file_path = "#{RAILS_ROOT}/public/uploads/#{@file_name}-materials.zip"
    @ja_materials = Array.new
    @ja_referrals = Array.new
    filepaths = Array.new
    counter = 1
    material_id_hash = Hash.new
    
    @applicants = @job.applicants
    @applications = JobApplication.find(:all, :conditions => {:job_id => @job.id})
    
    @applications.each do |app|
      @ja_materials << JobApplicationMaterial.find(:first, :conditions => {:job_application_id => app.id})
      unless @ja_referrals.nil?
        @ja_referrals << JobApplicationReferral.find(:all, :conditions => {:job_application_id => app.id})
      end  
    end  
    
    unless @ja_referrals.nil?
      if @material_types.include?("Proposed Work")
        @material_types.insert(@material_types.index("Proposed Work") + 1, "Referral")
      elsif @material_types.include?("Cover Letter")
        @material_types.insert(@material_types.index("Cover Letter") + 1, "Referral")
      elsif @material_types.include?("Resume or CV")
        @material_types.insert(@material_types.index("Resume or CV") + 1, "Referral")
      else 
        @material_types.insert(@material_types.index("Resume or CV") + 1, "Referral")
      end  
    end
      
    @material_types.each do |material|
      material_id_hash[material] = "%03d" % counter.to_s + "_" + material.gsub(/ /, '_')
      counter = counter + 1
    end
    
    # check to see if the file exists already, and if it does, delete it.
    if File.file?(@zip_file_path)
      File.delete(@zip_file_path)
    end
    
    Zip::ZipFile.open(@zip_file_path, Zip::ZipFile::CREATE) do |zipfile|
      @applicants.each do |applicant|
        zipfile.mkdir("#{applicant.last_name}_#{applicant.first_name}")  
      end  
      
      unless @ja_materials.nil?
        @ja_materials.each do |jam|
          jam.attachments.each do |jama|
            ext_name = File.extname("#{RAILS_ROOT}/files/" + jama.disk_filename)
            new_file_name = "#{Applicant.find(JobApplication.find(jam.job_application_id).applicant_id).last_name}_#{Applicant.find(JobApplication.find(jam.job_application_id).applicant_id).first_name}_#{material_id_hash[jama.description]}_#{jam.job_application_id}#{ext_name}"
            orig_file_path = "#{RAILS_ROOT}/files/" + jama.disk_filename
            if File.exists?(orig_file_path)
              orig_file_name = File.basename(orig_file_path)
              if zipfile.find_entry(new_file_name)
                zipfile.remove(new_file_name)
              end
              zipfile.get_output_stream("#{Applicant.find(JobApplication.find(jam.job_application_id).applicant_id).last_name}_#{Applicant.find(JobApplication.find(jam.job_application_id).applicant_id).first_name}/" + new_file_name) do |f|
                input = File.open(orig_file_path)
                data_to_copy = input.read()
                f.write(data_to_copy)
              end
            else
              puts "Warning: file #{orig_file_path} does not exist"
            end
          end    
        end
      end   

      unless @ja_referrals.nil?
        @ja_referrals.each do |jar|
          jar.each do |ref|
            ref.attachments.each do |jara|
              ext_name = File.extname("#{RAILS_ROOT}/files/" + jara.disk_filename)
              new_file_name = "#{Applicant.find(JobApplication.find(ref.job_application_id).applicant_id).last_name}_#{Applicant.find(JobApplication.find(ref.job_application_id).applicant_id).first_name}_#{material_id_hash[jama.description]}_#{ref.attachments.index(jara)+1}_#{ref.job_application_id}#{ext_name}"
              
              orig_file_path = "#{RAILS_ROOT}/files/" + jara.disk_filename
              if File.exists?(orig_file_path)
                orig_file_name = File.basename(orig_file_path)
                if zipfile.find_entry(new_file_name)
                  zipfile.remove(new_file_name)
                end
                zipfile.get_output_stream("#{Applicant.find(JobApplication.find(ref.job_application_id).applicant_id).last_name}_#{Applicant.find(JobApplication.find(ref.job_application_id).applicant_id).first_name}/" + new_file_name) do |f|
                  input = File.open(orig_file_path)
                  data_to_copy = input.read()
                  f.write(data_to_copy)
                end
              else
                puts "Warning: file #{orig_file_path} does not exist"
              end
            end  
          end    
        end
      end
    end
    
    @zipped_file = "/uploads/#{@file_name}-materials.zip"
    redirect_to job_path(@job, :apptracker_id => @job.apptracker_id, :zipped_file => @zipped_file)
    
  end
  
  def zip_some
    @job = Job.find(params[:job])
    @material_types = params[:application_material_types]
    @file_name = @job.title.gsub(/ /, '-')
    @zip_file_path = "#{RAILS_ROOT}/public/uploads/#{@file_name}-materials.zip"
    filepaths = Array.new
    counter = 1
    material_id_hash = Hash.new
    @ja_materials = Array.new
    if params[:applicant_referral]
      @ja_referrals = Array.new
    end
    applicants = Array.new
    unless params[:applicants_to_zip].nil?
      params[:applicants_to_zip].each do |ja|
        applicants << JobApplication.find(ja).applicant.id
      end
    end
    @applications = JobApplication.find(:all, :conditions => ["job_id = ? and applicant_id in (?)", @job.id, applicants])
    
    @applications.each do |app|
      @ja_materials << JobApplicationMaterial.find(:first, :conditions => {:job_application_id => app.id})
      unless @ja_referrals.nil?
        @ja_referrals << JobApplicationReferral.find(:all, :conditions => {:job_application_id => app.id})
      end  
    end  
    
    unless @ja_referrals.nil?
      if @material_types.include?("Proposed Work")
        @material_types.insert(@material_types.index("Proposed Work") + 1, "Referral")
      elsif @material_types.include?("Cover Letter")
        @material_types.insert(@material_types.index("Cover Letter") + 1, "Referral")
      elsif @material_types.include?("Resume or CV")
        @material_types.insert(@material_types.index("Resume or CV") + 1, "Referral")
      else 
        @material_types.insert(@material_types.index("Resume or CV") + 1, "Referral")
      end  
    end
      
    @material_types.each do |material|
      material_id_hash[material] = "%03d" % counter.to_s + "_" + material.gsub(/ /, '_')
      counter = counter + 1
    end
    
    # check to see if the file exists already, and if it does, delete it.
    if File.file?(@zip_file_path)
      File.delete(@zip_file_path)
    end
    
    Zip::ZipFile.open(@zip_file_path, Zip::ZipFile::CREATE) do |zipfile|
      unless @ja_materials.nil?
        @ja_materials.each do |jam|
          jam.attachments.each do |jama|
            @material_types.each do |mt|
              if mt == jama.description
                ext_name = File.extname("#{RAILS_ROOT}/files/" + jama.disk_filename)
                new_file_name = "#{Applicant.find(JobApplication.find(jam.job_application_id).applicant_id).last_name}_#{Applicant.find(JobApplication.find(jam.job_application_id).applicant_id).first_name}_#{material_id_hash[jama.description]}_#{jam.job_application_id}#{ext_name}"
                orig_file_path = "#{RAILS_ROOT}/files/" + jama.disk_filename
                if File.exists?(orig_file_path)
                  orig_file_name = File.basename(orig_file_path)
                  if zipfile.find_entry(new_file_name)
                    zipfile.remove(new_file_name)
                  end
                  zipfile.get_output_stream(new_file_name) do |f|
                    input = File.open(orig_file_path)
                    data_to_copy = input.read()
                    f.write(data_to_copy)
                  end
                else
                  puts "Warning: file #{file_path} does not exist"
                end
              end  
            end  
          end    
        end 
      end  

      unless @ja_referrals.nil?
        @ja_referrals.each do |jar|
          jar.each do |ref|
            ref.attachments.each do |jara|
              ext_name = File.extname("#{RAILS_ROOT}/files/" + jara.disk_filename)
              new_file_name = "#{Applicant.find(JobApplication.find(ref.job_application_id).applicant_id).last_name}_#{Applicant.find(JobApplication.find(ref.job_application_id).applicant_id).first_name}_#{material_id_hash[jama.description]}_#{ref.attachments.index(jara)+1}_#{ref.job_application_id}#{ext_name}"
              
              orig_file_path = "#{RAILS_ROOT}/files/" + jara.disk_filename
              if File.exists?(orig_file_path)
                orig_file_name = File.basename(orig_file_path)
                if zipfile.find_entry(new_file_name)
                  zipfile.remove(new_file_name)
                end
                zipfile.get_output_stream(new_file_name) do |f|
                  input = File.open(orig_file_path)
                  data_to_copy = input.read()
                  f.write(data_to_copy)
                end
              else
                puts "Warning: file #{file_path} does not exist"
              end
            end  
          end    
        end
      end
    end
    
    @zipped_file = "/uploads/#{@file_name}-materials.zip"
    redirect_to job_path(@job, :apptracker_id => @job.apptracker_id, :zipped_file => @zipped_file)
  end  
  
  
  
  def register
    redirect_to(home_url) && return unless Setting.self_registration? || session[:auth_source_registration]
    if request.post?
      @user = User.new(params[:user])
      @user.admin = false
      @user.register
      
      @user.login = params[:user][:login]
      @user.password, @user.password_confirmation = params[:password], params[:password_confirmation]
      # Automatic activation
      @user.activate
      @user.last_login_on = Time.now
      if @user.save
        self.logged_user = @user
        flash[:notice] = "Your account has been created. You are now logged in."
      else
        flash[:error] = "Your account could not be created."
      end
      redirect_to :back
    else
      redirect_to(home_url)    
    end  
  end
end
