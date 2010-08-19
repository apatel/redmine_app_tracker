class ApptrackersController < ApplicationController
  unloadable # don't keep reloading this
  #before_filter :require_admin, :except => [:index, :show] 

  # The landing page; displays all apptrackers owned by the project
  # GET /apptrackers
  # GET apptrackers_url
  def index
    # retrieve the current project id; needed for declaring a project's ownership over a new apptracker
    session[:project_id] = Project.find(params[:project_id])
    @apptrackers = Apptracker.find(:all, :conditions => ["project_id = ?", session[:project_id]])
  end
  
  # GET /apptrackers/1
  # GET apptracker_url(:id => 1)
  def show
    @apptracker = Apptracker.find(params[:id])
    session[:apptracker_id] = params[:id]
    session[:apptracker_title] = @apptracker.title
  end

  # GET /apptrackers/new
  # Get new_apptracker_url
  def new
    @apptracker = Apptracker.new
  end

  # GET /apptrackers/1/edit
  # GET edit_apptracker_url(:id => 1)
  def edit
    @apptracker = Apptracker.find(params[:id])
  end
  
  # POST /apptrackers
  # POST apptrackers_url
  def create
    @apptracker = Apptracker.create(params[:apptracker])

    # attempt to save the apptracker; flash results to the user
    @apptracker.save ? flash[:notice] = "#{@apptracker.title} has been created." : flash.now[:error] = "#{@apptracker.title} could not be created"

    redirect_to(apptrackers_url)
  end

  # PUT /apptrackers/1
  # PUT apptracker_url(:id => 1)
  def update
    @apptracker = Apptracker.find(params[:id])

    # attempt to update apptracker attributes; flash results to the user
    @apptracker.update_attributes(params[:apptracker]) ? flash[:notice] = "#{@apptracker.title} has been updated." : flash[:error] = "#{@apptracker.title} could not be updated."

    redirect_to(apptrackers_url)
  end

  # DELETE /apptrackers/1
  # DELETE apptracker_url(:id => 1)
  def destroy
    @apptracker = Apptracker.find(params[:id])

    # attempt to destroy the apptracker; flash results to the user
    @apptracker.destroy ? flash[:notice] = "#{@apptracker.title} has been deleted." : flash[:error] = "Error: #{@apptracker.title} could not be deleted."

    redirect_to(apptrackers_url)
  end
end
