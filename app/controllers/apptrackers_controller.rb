class ApptrackersController < ApplicationController
  #unloadable # don't keep reloading this
  before_filter :require_admin, :except => [:index, :show] 

  # The landing page; displays all apptrackers owned by the project
  # GET /apptrackers
  # GET apptrackers_url
  # TODO find out if there's a field in redmine that indicates the most recent project accessed
  # TODO implement XML routing?
  def index
    # if calling from a project's apptracker tab, :project_name will exist, and apptrackers
    # owned by the project can be searched for
    if(!params[:project_name].nil?)
      session[:project_id] = Project.find(params[:project_name]).id
    end

    if(session[:project_id].nil?)
      # if no :project_id exists, a project's apptrackers can't be found, so redirect back to projects
      redirect_to('/projects')
    else
      # otherwise, display a project's apptrackers
      @apptrackers = Apptracker.find(:all, :conditions => ["project_id = ?", session[:project_id]])
      # if a logged-in, non-admin user has landed here, then session[:applicant_id] will need to be set to session[:user_id]
      if(!User.current.admin? && User.current.logged?)
        session[:applicant_id] = session[:user_id]
      end
    end
  end
  
  # GET /apptrackers/1
  # GET apptracker_url(:id => 1)
  def show
    @apptracker = Apptracker.find(params[:id])
    session[:apptracker_id] = @apptracker.id
    session[:apptracker_title] = @apptracker.title

    respond_to do |format|
      format.html #show.html.erb
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
    @apptracker = Apptracker.new(params[:apptracker])
    @apptracker.project_id = session[:project_id]
    @apptracker.apptracker_status = 'active'

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
