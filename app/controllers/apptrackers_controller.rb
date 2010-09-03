class ApptrackersController < ApplicationController
  #unloadable # don't keep reloading this
  before_filter :require_admin, :except => [:index, :show] 

  # The landing page; displays all apptrackers owned by the project
  # GET /apptrackers
  # GET apptrackers_url
  def index
    # The :project_identifier parameter must exist, otherwise redirect back to projects
    if(!params[:project_identifier].nil?)
      @project = Project.find_by_identifier(params[:project_identifier])
    else
      redirect_to('/projects')
    end

    # display a project's apptrackers
    @apptrackers = Apptracker.find(:all, :conditions => ["project_id = ?", @project.id])
  end
  
  # GET /apptrackers/1
  # GET apptracker_url(:id => 1)
  def show
    @apptracker = Apptracker.find(params[:id])

    respond_to do |format|
      format.html { redirect_to(jobs_url(:apptracker_id => @apptracker.id)) }#show.html.erb
    end
  end

  # GET /apptrackers/new
  # Get new_apptracker_url
  def new
    @apptracker = Apptracker.new

    respond_to do |format|
        format.html #new.html.erb
    end
  end
  
  # POST /apptrackers
  # POST apptrackers_url
  def create
    debugger
    @apptracker = Apptracker.new(params[:apptracker])
    @apptracker.project = @project

    # attempt to save the apptracker; flash results to the user
    respond_to do |format|
      if(@apptracker.save)
        # no errors, redirect with success message
        format.html { redirect_to(@apptracker, :notice => "#{@apptracker.title} has been created.") }
      else
        # validation prevented save
        format.html { render :action => "new" }
      end
    end
  end

  # GET /apptrackers/1/edit
  # GET edit_apptracker_url(:id => 1)
  def edit
    @apptracker = Apptracker.find(params[:id])
  end

  # PUT /apptrackers/1
  # PUT apptracker_url(:id => 1)
  def update
    @apptracker = Apptracker.find(params[:id])
    
    # attempt to update apptracker attributes; flash results to the user
    respond_to do |format|
      if @apptracker.update_attributes(params[:apptracker])
        # no errors, redirect with success message
        format.html { redirect_to(apptrackers_url, :notice => "#{@apptracker.title} has been updated.") }
     else
        # validation prevented update; redirect to edit form with error messages
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /apptrackers/1
  # DELETE apptracker_url(:id => 1)
  def destroy
    @apptracker = Apptracker.find(params[:id])

    # attempt to destroy the apptracker; flash results to the user
    @apptracker.destroy ? flash[:notice] = "#{@apptracker.title} has been deleted." : flash[:error] = "Error: #{@apptracker.title} could not be deleted."
    respond_to do |format|
      format.html { redirect_to(apptrackers_url) }
    end
  end
end
