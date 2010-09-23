class JobsController < ApplicationController
  unloadable
  before_filter :require_admin, :except => [:index, :show] 

  # GET /jobs
  # GET jobs_url
  def index
    # secure the parent apptracker id and find its jobs
    @apptracker = Apptracker.find(params[:apptracker_id])
    if(User.current.admin?)
      @jobs = @apptracker.jobs
    else
      @jobs = @apptracker.jobs.find(:all, :conditions => ["status = ?", Job::JOB_STATUS[0]])
    end
  end
  
  # GET /jobs/1
  # GET job_url(:id => 1)
  def show
    # secure the parent apptracker id and find requested job
    @apptracker = Apptracker.find(params[:apptracker_id])
    @job = @apptracker.jobs.find(params[:id])

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
    respond_to do |format|
      if(params[:form][:form_id].to_i == 1)
        if(@job.save)
          # no errors, redirect to second part of form
          format.html { redirect_to(new_job_url(:apptracker_id => @apptracker.id, :job_id => @job.id)) }
        else
          # validation prevented save; redirect back to new.html.erb with error messages
          format.html { render :action => "new" }
        end
      else
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
        # no errors, redirect with success message
        format.html { redirect_to(jobs_url(:apptracker_id => @apptracker.id), :notice => "\'#{@job.title}\' has been updated.") }
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
end
