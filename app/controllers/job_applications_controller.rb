class JobApplicationsController < ApplicationController
  unloadable
  # TODO make sure an applicant cannot add a new job application to a job they have already applied to
  # TODO find out how to use authentication for allowing access to :new and :edit actions
  before_filter :require_admin, :except => [:index, :show, :new, :edit, :create, :update, :destroy] 

  helper :attachments
  include AttachmentsHelper
  helper :custom_fields
  include CustomFieldsHelper
  helper :sort
  include SortHelper
  
  # GET /job_applications
  # GET job_applications_url
  def index
    # TODO establish calling page in order to return proper search results (from job scope or applicant scope)
    
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
      @job_applications = @applicant.job_applications
      @apptracker = Apptracker.find(params[:apptracker_id])
    end
  end
  
  # GET /job_applications/1
  # GET job_application_url(:id => 1)
  def show
    # secure the parent apptracker id and find requested job_application
    @job_application = JobApplication.find(params[:id])
    @applicant = @job_application.applicant
    
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
      @job_application = @applicant.job_applications.new
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
    #p "Job Application Custom Fields"
    #p @job.job_application_custom_fields
    #@applicant = Applicant.find_by_email(User.current.mail)
    @applicant = @job_application.applicant
    @apptracker = Apptracker.find(params[:apptracker_id])
    @job_application_materials = @job_application.job_application_materials.find :all, :include => [:attachments]
  end

  # POST /job_applications
  # POST job_applications_url
  def create
    # create a job_application connected to its parent applicant
    @applicant = Applicant.find_by_email(User.current.mail)
    @job_application = @applicant.job_applications.new(params[:job_application])
    @job_application[:submission_status] = "Submitted"
    respond_to do |format|
      if(@job_application.save)
        #if job application saved then create the job application material
        job_app_file = Hash.new
        job_app_file["job_application_id"] = @job_application.id
        @job_application_material = @job_application.job_application_materials.build(job_app_file)
        @job_application_material.save
        attachments = Attachment.attach_files(@job_application_material, params[:attachments])
        render_attachment_warning_if_needed(@job_application_material)
        
        #send referrer emails
        @emails = params[:email].split(',')
        @emails.each do |email|
          Notification.deliver_request_referral(@job_application, email)
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
    end
  end

  # PUT /job_applications/1
  # PUT job_application_url(:id => 1)
  def update
    # find the job_application within its parent applicant
    @applicant = Applicant.find(params[:job_application][:applicant_id])
    @job_application = @applicant.job_applications.find(params[:id])
    
    job_app_file = Hash.new
    job_app_file["job_application_id"] = @job_application.id
    #job_app_file["title"] = @job.title
    #job_app_file["filename"] = @job.title
    #job_app_file["notes"] = @job.title
    @job_application_material = @job_application.job_application_materials.find :first
    attachments = Attachment.attach_files(@job_application_material, params[:attachments])
    render_attachment_warning_if_needed(@job_application_material) 
        
    # update the job_application's attributes, and indicate a message to the user opon success/failure
    respond_to do |format|
      if(@job_application.update_attributes(params[:job_application]))
        #send referrer emails
        @emails = params[:email].split(',')
        @emails.each do |email|
          Notification.deliver_request_referral(@job_application, email)
        end
        
        #Send Notification
        Notification.deliver_application_updated(@job_application)
        # no errors, redirect with success message
        format.html { redirect_to(job_applications_url(:apptracker_id => @job_application.apptracker_id, :applicant_id => @job_application.applicant_id), :notice => "#{@job_application.applicant.first_name} #{@job_application.applicant.last_name}\'s information has been updated.") }
      else
        # validation prevented update; redirect to edit form with error messages

      end
    end
  end

  # DELETE /job_applications/1
  # DELETE job_application_url(:id => 1)
  def destroy
    # create a job_application in the context of its parent applicant
    @job_application = JobApplication.find(params[:id])
    @applicant = Applicant.find(@job_application.applicant_id)
    @apptracker = Apptracker.find(@job_application.apptracker_id)
    

    # destroy the job_application, and indicate a message to the user upon success/failure
    @job_application.destroy ? flash[:notice] = "#{@applicant.first_name} #{@applicant.last_name}\'s record has been deleted." : flash[:error] = "Error: #{@applicant.first_name} #{@applicant.last_name}\'s record could not be deleted."
    
    respond_to do |format|
      format.html { redirect_to(job_applications_url(:apptracker_id => @apptracker.id, :applicant_id => @applicant.id)) }
    end
  end
end
