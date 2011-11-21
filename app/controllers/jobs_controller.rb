require 'rubygems'
require 'zip/zipfilesystem'

class JobsController < ApplicationController
  unloadable
  before_filter :require_admin, :except => [:index, :show]
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
    sort_update %w(title category description status submission_date)
    
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
    
    respond_to do |format|
      format.html #show.html.erb
    end
  end

  # GET /jobs/new
  # Get new_job_url
  def new
    # secure the parent apptracker id and create a new job
    @apptracker = Apptracker.find(params[:apptracker_id])
    @jobs = @apptracker.jobs
    
    if(params[:job_id].nil?)
    #if(params[:form_sect].to_i == 1)
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
    if(params[:form][:form_id].to_i == 1)
      @job = @apptracker.jobs.new(params[:job])
    else
      @job = @apptracker.jobs.find(params[:job_id])
    end    
    @job.application_material_types = params[:application_material_types].join(",")
    respond_to do |format|
      if(params[:form][:form_id].to_i == 1)
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
      else
        p "in the second form"
        if(@job.update_attributes(params[:job]))
          format.html { redirect_to(jobs_url(:apptracker_id => @apptracker.id), :notice => "\'#{@job.title}\' has been updated.") }
        else
          format.html { render :action => "new" }
        end
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
    @jobs = @apptracker.jobs

    @custom_field = begin
      "JobApplicationCustomField".to_s.constantize.new(params[:custom_field])
    rescue
    end
    p "custom fields"
    p @job.all_job_app_custom_fields
    
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
        @job.application_material_types = params[:application_material_types].join(",")
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
    job = Job.find_by_id params[:id]
    custom_field = CustomField.create!(params[:custom_field])
    custom_field.type = "JobApplicationCustomField"
    if custom_field.save
      flash[:notice] = l(:notice_successful_create)
      call_hook(:controller_custom_fields_new_after_save, :params => params, :custom_field => custom_field)
      cf = {"job_application_custom_field_ids" => [custom_field.id]}
      job.attributes = cf
      job.save
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
  
  def print_materials    
    @job = Job.find(params[:job])
    @material_types = params[:application_material_types]
    @ja_materials = []
    @applications = @job.job_applications
    if params[:applicant_referral]
      @ja_referrals = []
    end
    @applications.each do |app|
      @ja_materials << JobApplicationMaterial.find(:first, :conditions => {:job_application_id => app.id})
      unless @ja_referrals.nil?
        @ja_referrals << JobApplicationReferral.find(:all, :conditions => {:job_application_id => app.id})
      end  
    end   
  
    filepaths = []
    @ja_materials.each do |jam|
      jam.attachments.each do |jama|
        @material_types.each do |mt|
          if mt.include? jama.description
            filepaths << "#{RAILS_ROOT}/files/" + jama.disk_filename
          end  
        end
      end    
    end 
    
    unless @ja_referrals.nil?
      @ja_referrals.each do |jar|
        jar.each do |ref|
          ref.attachments.each do |jara|
            filepaths << "#{RAILS_ROOT}/files/" + jara.disk_filename
          end  
        end    
      end
    end 
    
    @file_name = @job.title.sub(/ /, '-')  
    zip("#{RAILS_ROOT}/public/uploads/#{@file_name}-materials.zip", filepaths)
    @zipped_file = "/uploads/#{@file_name}-materials.zip"
    p "zipped"
    p @zipped_file
    
    redirect_to job_path(@job, :apptracker_id => @job.apptracker_id, :zipped_file => @zipped_file)
  end  
  
  def zip(zip_file_path, list_of_file_paths)

    @zip_file_path = zip_file_path
    list_of_file_paths = [list_of_file_paths] if list_of_file_paths.class == String
    @list_of_file_paths = list_of_file_paths
    
    # check to see if the file exists already, and if it does, delete it.
    if File.file?(@zip_file_path)
      File.delete(@zip_file_path)
    end

    Zip::ZipFile.open(@zip_file_path, Zip::ZipFile::CREATE) do |zipfile|
      @list_of_file_paths.each do | file_path |
        if File.exists?file_path
          file_name = File.basename( file_path )
          if zipfile.find_entry( file_name )
            zipfile.replace( file_name, file_path )
          else
            zipfile.add( file_name, file_path)
          end
        else
          puts "Warning: file #{file_path} does not exist"
        end
      end
    end
  end
  
end
