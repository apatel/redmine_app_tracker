class JobApplicationsController < ApplicationController
  unloadable
  # TODO make sure an applicant cannot add a new job application to a job they have already applied to
  # TODO find out how to use authentication for allowing access to :new and :edit actions
  before_filter :require_admin, :except => [:index, :show, :new, :edit, :create, :update, :destroy] 

#  before_filter :access_check, :except => [:index, :new]

  helper :attachments
  include AttachmentsHelper
  helper :custom_fields
  include CustomFieldsHelper
  helper :sort
  include SortHelper
  
  # GET /job_applications
  # GET job_applications_url
  def index
    sort_init 'created_at', 'desc'
    sort_update 'last_name' => "#{Applicant.table_name}.last_name",
                'id' => "#{JobApplication.table_name}.id",
                'submission_status' => "#{JobApplication.table_name}.submission_status",
                'acceptance_status' => "#{JobApplication.table_name}.acceptance_status",
                'created_at' => "#{JobApplication.table_name}.created_at"
    #sort_update %w(id submission_status, acceptance_status, created_at)
    
    if(User.current.admin?)
      @apptracker = Apptracker.find(params[:apptracker_id])
      if(params[:view_scope] == 'job' || (params[:applicant_id].nil? && params[:apptracker_id].nil?))
        # if viewing all job applications for a particular job
        @job_applications = Job.find(params[:job_id]).job_applications
      elsif(params[:view_scope] == 'applicant' || (params[:job_id].nil? && params[:apptracker_id].nil?))
        # if viewing all job applications for a particular user/applicant
        @job_applications = Applicant.find(params[:applicant_id]).job_applications
      else
        # if viewing all job applications for an apptracker
        @jobs = Apptracker.find(params[:apptracker_id]).jobs
        @job_applications = Array.new
        @jobs.each do |job|
          @job_applications << job.job_applications
        end
      end
      @job_applications.flatten!

    elsif(User.current.logged?)
      @applicant = Applicant.find_by_email(User.current.mail)
      @job_applications = @applicant.nil? ? nil : @applicant.job_applications
      @apptracker = Apptracker.find(params[:apptracker_id])
    end
  end
  
  # GET /job_applications/1
  # GET job_application_url(:id => 1)
  def show
    # secure the parent apptracker id and find requested job_application
    @job_application = JobApplication.find(params[:id])
    @applicant = @job_application.applicant

	unless User.current.admin? || @applicant.email == User.current.mail
		redirect_to('/') and return
	end
    
# note these two lines are NOT the same, one is job materials the other is job referrals
    @job_application_materials = @job_application.job_application_materials.find :all, :include => [:attachments]
    @job_application_referrals = @job_application.job_application_referrals.find :all, :include => [:attachments]
    
    respond_to do |format|
      format.html #show.html.erb
    end
  end

  # GET /job_applications/new
  # Get new_job_application_url
  def new
    # secure the parent applicant id and create a new job_application

    @applicant = Applicant.find_by_email(User.current.mail)
    @apptracker = Apptracker.find(params[:apptracker_id])
    @job = Job.find params[:job_id]
    
    if @applicant.nil?
      redirect_to(new_applicant_url(:apptracker_id => @apptracker.id, :job_id => @job.id))
    else
      @job_application = JobApplication.new(:job => @job, :applicant => @applicant)
      respond_to do |format|
        format.html # new.html.erb
      end
    end  
    
  end

  # GET /job_applications/1/edit
  # GET edit_job_application_url(:id => 1)
  def edit
    @job_application = JobApplication.find(params[:id])
    @job = Job.find @job_application.job_id
    @applicant = @job_application.applicant
	unless User.current.admin? || @applicant.email == User.current.mail
		redirect_to('/') and return
	end
    @apptracker = Apptracker.find(params[:apptracker_id])
    @job_application_materials = @job_application.job_application_materials.find :all, :include => [:attachments]
  end

  # POST /job_applications
  # POST job_applications_url
  def create
    @applicant = Applicant.find_by_email(User.current.mail)
    @job = Job.find params[:job_application][:job_id]
    @job_application = JobApplication.new(:job => @job, :applicant => @applicant)
    
    
    @apptracker = Apptracker.find(params[:job_application][:apptracker_id])
    
    #prepare the job application material attachments
    materials = @job_application.job.application_material_types.split(',')
    error_files = Array.new
    unless params[:attachments].nil?
      i = 1
      materials.each do |amt|
        unless params[:attachments][i.to_s].nil?
          params[:attachments][i.to_s]['description'] = amt
        else
          error_files << amt  
        end  
        i = i + 1
      end 
    else
      error_files = materials  
    end
    
    respond_to do |format|
      if error_files.empty?
        flash.now[:error] = nil
        @job_application.update_attributes(params[:job_application])
        @job_application[:submission_status] = "Submitted"
        if(@job_application.save)
          # #if job application saved then create the job application material
          job_app_file = Hash.new
          job_app_file["job_application_id"] = @job_application.id
          @job_application_material = @job_application.job_application_materials.build(job_app_file)
          @job_application_material.save
        
          attachments = Attachment.attach_files(@job_application_material, params[:attachments])
          render_attachment_warning_if_needed(@job_application_material)
        
          #send referrer emails
          unless params[:email].nil?
            @emails = params[:email].split(',')
            @emails.each do |email|
              Notification.deliver_request_referral(@job_application, email)
            end
          end
      
          #Send Notification
          Notification.deliver_application_submitted(@job_application) 
        
          flash[:notice] = l(:notice_successful_create)
          # no errors, redirect with success message
          format.html { redirect_to(job_applications_url(:apptracker_id => @job_application.apptracker_id, :applicant_id => @job_application.applicant_id), :notice => "Application has been submitted.") }
        else
          # validation prevented save; redirect back to new.html.erb with error messages
          format.html { render :action => "new" }
        end
      else
        flash.now[:error] = nil
        # job material validation prevented save; redirect back to new.html.erb with error messages
        flash.now[:error] = nil
        message = ""
        error_files.each do |material|
          line = material + " " + "cannot be empty."
          message = message + line + "\n"
        end
        message = message + "You will need to re-upload all documents."
        flash.now[:error] = message
        @job_application.attributes = params[:job_application]
        format.html { render :action => "new" }  
      end  
    end  
  end

  # PUT /job_applications/1
  # PUT job_application_url(:id => 1)
  def update
    # find the job_application within its parent applicant
    @applicant = Applicant.find(params[:job_application][:applicant_id])
	unless User.current.admin? || @applicant.email == User.current.mail
		redirect_to('/') and return
	end
    @job_application = @applicant.job_applications.find(params[:id])
    
    @job = Job.find @job_application.job_id
    @apptracker = Apptracker.find(params[:job_application][:apptracker_id])
    @job_application_materials = @job_application.job_application_materials.find :all, :include => [:attachments]
        
    # update the job_application's attributes, and indicate a message to the user opon success/failure
    respond_to do |format|
      if(@job_application.update_attributes(params[:job_application]))
        # attach files
        job_app_file = Hash.new
        job_app_file["job_application_id"] = @job_application.id
        @job_application_material = @job_application.job_application_materials.find :first
        materials = @job_application.job.application_material_types.split(',')
        i = 1
        materials.each do |amt|
          unless params[:attachments].nil? || params[:attachments][i.to_s].nil? || params[:attachments][i.to_s]['file'].nil?
            params[:attachments][i.to_s]['description'] = amt
          end  
          i = i + 1
        end
        
        attachments = Attachment.attach_files(@job_application_material, params[:attachments])
        render_attachment_warning_if_needed(@job_application_material)
        
        unless params[:email].nil?
          #send referrer emails
          @emails = params[:email].split(',')
          @emails.each do |email|
            Notification.deliver_request_referral(@job_application, email)
          end
        end
        
        #Send Notification
        Notification.deliver_application_updated(@job_application)
        # no errors, redirect with success message
        if(User.current.admin?)
          format.html { redirect_to(job_url(@job_application.job_id, :apptracker_id => @job_application.apptracker_id), :notice => "#{@job_application.applicant.first_name} #{@job_application.applicant.last_name}\'s information has been updated.") }
        else  
          format.html { redirect_to(job_applications_url(:apptracker_id => @job_application.apptracker_id, :applicant_id => @job_application.applicant_id), :notice => "#{@job_application.applicant.first_name} #{@job_application.applicant.last_name}\'s information has been updated.") }
        end  
      else
        # validation prevented update; redirect to edit form with error messages
        format.html { render :action => "edit"}
      end
    end
  end

  # DELETE /job_applications/1
  # DELETE job_application_url(:id => 1)
  def destroy
    # create a job_application in the context of its parent applicant
    @job_application = JobApplication.find(params[:id])
    @applicant = Applicant.find(@job_application.applicant_id)
	unless User.current.admin? || @applicant.email == User.current.mail
		redirect_to('/') and return
	end
    @apptracker = Apptracker.find(@job_application.apptracker_id)
    

    # destroy the job_application, and indicate a message to the user upon success/failure
    @job_application.destroy ? flash[:notice] = "#{@applicant.first_name} #{@applicant.last_name}\'s record has been deleted." : flash[:error] = "Error: #{@applicant.first_name} #{@applicant.last_name}\'s record could not be deleted."
    
    respond_to do |format|
      format.html { redirect_to(job_applications_url(:apptracker_id => @apptracker.id, :applicant_id => @applicant.id)) }
    end
  end
end
