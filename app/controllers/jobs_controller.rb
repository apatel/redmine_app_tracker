class JobsController < ApplicationController
  unloadable # don't keep reloading this
  before_filter :require_admin, :except => [:index, :show] 

  # GET /jobs
  # GET jobs_url
  def index
    @jobs = Job.find(:all)
  end
  
  # GET /jobs/1
  # GET job_url(:id => 1)
  def show
    @job = Job.find(params[:id])
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
    @job.save ? flash[:notice] = "#{@job.title} has been created." : flash.now[:error] = "#{@job.title} could not be created"
    redirect_to(jobs_url)
  end

  # PUT /jobs/1
  # PUT job_url(:id => 1)
  def update
    @job = Job.find(params[:id])
    @job.update_attributes(params[:job]) ? flash[:notice] = "#{@job.title} has been updated." : flash[:error] = "#{@job.title} could not be updated."
    redirect_to(jobs_url)
  end

  # DELETE /jobs/1
  # DELETE job_url(:id => 1)
  def destroy
    @job = Job.find(params[:id])
    flash[:notice] = "#{@job.title} has been deleted."
    @job.destroy ? flash[:notice] = "#{@job.title} has been deleted." : flash[:error] = "Error: #{job.title} could not be deleted."
    redirect_to(jobs_url)
  end
end
