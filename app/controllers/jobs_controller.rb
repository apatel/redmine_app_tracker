class JobsController < ApplicationController
  unloadable # don't keep reloading this
  # before_filter :require_admin, :except => [:index, :show] 

  # GET /jobs
  # GET jobs_url
  def index
    @jobs = Job.find(:all, :conditions => ["apptracker_id = ?", session[:apptracker_id]])
  
    # no job currently selected, session should reflect this
    session[:job_id] = nil
  end
  
  # GET /jobs/1
  # GET job_url(:id => 1)
  def show
    @job = Job.find(params[:id])

    # refresh the parent project and apptracker session settings; important if a link to the
    # current job are provided on other websites
    session[:job_id] = @job.id
    session[:apptracker_id] = @job.apptracker_id
    session[:project_id] = Apptracker.find(session[:apptracker_id]).project_id
  end

  # GET /jobs/new
  # Get new_job_url
  def new
    @job = Job.new
  end

  # GET /jobs/1/edit
  # GET edit_job_url(:id => 1)
  def edit
    @job = Job.find(params[:id])
  end
  
  # POST /jobs
  # POST jobs_url
  def create
    @job = Job.create(params[:job])

    # set the parent apptracker
    @job.apptracker_id = session[:apptracker_id]

    # attempt to save the job; flash result to the user
    @job.save ? flash[:notice] = "\'#{@job.title}\' has been created." : flash.now[:error] = "\'#{@job.title}\' could not be created"
    redirect_to(jobs_url)
  end

  # PUT /jobs/1
  # PUT job_url(:id => 1)
  def update
    @job = Job.find(params[:id])

    # update the job's attributes, and indicate a message to the user opon success/failure
    @job.update_attributes(params[:job]) ? flash[:notice] = "\'#{@job.title}\' has been updated." : flash[:error] = "\'#{@job.title}\' could not be updated."

    redirect_to(jobs_url)
  end

  # DELETE /jobs/1
  # DELETE job_url(:id => 1)
  def destroy
    @job = Job.find(params[:id])

    # destroy the job, and indicate a message to the user upon success/failure
    @job.destroy ? flash[:notice] = "\'#{@job.title}\' has been deleted." : flash[:error] = "Error: \'#{@job.title}\' could not be deleted."

    redirect_to(jobs_url)
  end
end
