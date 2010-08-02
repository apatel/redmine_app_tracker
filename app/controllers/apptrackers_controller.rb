class ApptrackersController < ApplicationController
  unloadable # don't keep reloading this
  before_filter :require_admin, :except => [:index, :show] 

  # GET /apptrackers
  # GET apptrackers_url
  def index
    @apptrackers = Apptracker.find(:all)
  end
  
  # GET /apptrackers/1
  # GET apptracker_url(:id => 1)
  def show
    @apptracker = Apptracker.find(params[:id])
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
    @apptracker.save ? flash[:notice] = "#{@apptracker.title} has been created." : flash.now[:error] = "#{@apptracker.title} could not be created"
    redirect_to(apptrackers_url)
  end

  # PUT /apptrackers/1
  # PUT apptracker_url(:id => 1)
  def update
    @apptracker = Apptracker.find(params[:id])
    @apptracker.update_attributes(params[:apptracker]) ? flash[:notice] = "#{@apptracker.title} has been updated." : flash[:error] = "#{@apptracker.title} could not be updated."
    redirect_to(apptrackers_url)
  end

  # DELETE /apptrackers/1
  # DELETE apptracker_url(:id => 1)
  def destroy
    @apptracker = Apptracker.find(params[:id])
    flash[:notice] = "#{@apptracker.title} has been deleted."
    @apptracker.destroy ? flash[:notice] = "#{@apptracker.title} has been deleted." : flash[:error] = "Error: #{apptracker.title} could not be deleted."
    redirect_to(apptrackers_url)
  end
end
