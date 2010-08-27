class JobsController < ApplicationController
  unloadable # don't keep reloading this
  # TODO find out how to access the parent apptracker via association
  before_filter :require_admin, :except => [:index, :show] 

  # GET /jobs
  # GET jobs_url
  def index
    # secure the parent apptracker id and find its jobs
    @apptracker = Apptracker.find(session[:apptracker_id])
    @jobs = @apptracker.jobs
  
    # no job currently selected, session should reflect this
    session[:job_id] = nil
  end
  
  # GET /jobs/1
  # GET job_url(:id => 1)
  def show
    # secure the parent apptracker id and find requested job
    @apptracker = Apptracker.find(session[:apptracker_id])
    @job = @apptracker.jobs.find(params[:id])

    # refresh the parent project and apptracker session settings; important if a link to the
    # current job are provided on other websites
    session[:job_id] = @job.id
    session[:apptracker_id] = @job.apptracker_id
    session[:project_id] = Apptracker.find(session[:apptracker_id]).project_id

    respond_to do |format|
      format.html #show.html.erb
    end
  end

  # GET /jobs/new
  # Get new_job_url
  def new
    # secure the parent apptracker id and create a new job
    @apptracker = Apptracker.find(session[:apptracker_id])
    @job = @apptracker.jobs.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /jobs/1/edit
  # GET edit_job_url(:id => 1)
  def edit
    # secure the parent apptracker id and find the job to edit
    @apptracker = Apptracker.find(session[:apptracker_id])
    @job = @apptracker.jobs.find(params[:id])
  end
  
  # POST /jobs
  # POST jobs_url
  def create
    # create a job in its parent apptracker
    @apptracker = Apptracker.find(session[:apptracker_id])
    @job = @apptracker.jobs.new(params[:job])
 
    respond_to do |format|
      if(@job.save)
        # no errors, redirect with success message
        format.html { redirect_to(@job, :notice => "\'#{@job.title}\' has been created.") }
      else
        # validation prevented save; redirect back to new.html.erb with error messages
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /jobs/1
  # PUT job_url(:id => 1)
  def update
    # find the job within its parent apptracker
    @apptracker = Apptracker.find(session[:apptracker_id])
    @job = @apptracker.jobs.find(params[:id])

    # update the job's attributes, and indicate a message to the user opon success/failure
    respond_to do |format|
      if(@job.update_attributes(params[:job]))
        # no errors, redirect with success message
        format.html { redirect_to(jobs_url, :notice => "\'#{@job.title}\' has been updated.") }
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
    @apptracker = Apptracker.find(session[:apptracker_id])
    @job = @apptracker.jobs.find(params[:id])

    # destroy the job, and indicate a message to the user upon success/failure
    @job.destroy ? flash[:notice] = "\'#{@job.title}\' has been deleted." : flash[:error] = "Error: \'#{@job.title}\' could not be deleted."
    
    respond_to do |format|
      format.html { redirect_to(jobs_url) }
    end
  end
end
