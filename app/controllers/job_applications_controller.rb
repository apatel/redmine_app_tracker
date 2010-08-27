class JobApplicationsController < ApplicationController
  unloadable
  # TODO make sure an applicant cannot add a new job application to a job they have already applied to
  # TODO find out how to use authentication for allowing access to :new and :edit actions
  before_filter :require_admin, :except => [:index, :show, :new, :edit] 

  # GET /job_applications
  # GET job_applications_url
  def index
    # TODO establish calling page in order to return proper search results (from job scope or applicant scope)
    @apptracker = Apptracker.find(session[:apptracker_id])
    
    # TODO REVISE THIS
    @job_materials = @apptracker.applicants.job_applications

    # @applicant = @apptracker.applicants.find(session[:applicant_id])
    # @job_applications = @applicant.job_applications
    
    # no job_application currently selected, session should reflect this
    session[:job_application_id] = nil
  end
  
  # GET /job_applications/1
  # GET job_application_url(:id => 1)
  def show
    # secure the parent apptracker id and find requested job_application
    @job_application = Referrer.find(params[:id])
    @applicant = @job_application.applicant

    # indicate current job_application id and applicant id in the session
    session[:job_application_id] = @job_application.id
    session[:applicant_id] = @job_application.applicant.id

    respond_to do |format|
      format.html #show.html.erb
    end
  end

  # GET /job_applications/new
  # Get new_job_application_url
  def new
    # secure the parent applicant id and create a new job_application
    @applicant = Applicant.find(session[:applicant_id])
    @job_application = @applicant.job_applications.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /job_applications/1/edit
  # GET edit_job_application_url(:id => 1)
  def edit
    @job_application = Referrer.find(params[:id]) 
  end

  # POST /job_applications
  # POST job_applications_url
  def create
    # create a job_application connected to its parent applicant
    @applicant = Applicant.find(session[:applicant_id])
    @job_application = @applicant.job_applications.new(params[:job_application])
 
    respond_to do |format|
      if(@job_application.save)
        # no errors, redirect with success message
        format.html { redirect_to(@job_application, :notice => "#{@job_application.first_name} #{@job_application.last_name} has been added as a job_application.") }
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
    @applicant = Applicant.find(session[:applicant_id])
    @job_application = @applicant.job_applications.find(params[:id])

    # update the job_application's attributes, and indicate a message to the user opon success/failure
    respond_to do |format|
      if(@job_application.update_attributes(params[:job_application]))
        # no errors, redirect with success message
        format.html { redirect_to(job_applications_url, :notice => "#{@job_application.first_name} #{@job_application.last_name}\'s information has been updated.") }
      else
        # validation prevented update; redirect to edit form with error messages

      end
    end
  end

  # DELETE /job_applications/1
  # DELETE job_application_url(:id => 1)
  def destroy
    # create a job_application in the context of its parent applicant
    @applicant = Applicant.find(session[:applicant_id])
    @job_application = @applicant.job_applications.find(params[:id])

    # destroy the job_application, and indicate a message to the user upon success/failure
    @job_application.destroy ? flash[:notice] = "#{@job_application.first_name} #{@job_application.last_name}\'s record has been deleted." : flash[:error] = "Error: #{@job_application.first_name} #{@job_application.last_name}\'s record could not be deleted."
    
    respond_to do |format|
      format.html { redirect_to(job_applications_url) }
    end
  end
end
