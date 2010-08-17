class ApplicationMaterialsController < ApplicationController
  unloadable # don't keep reloading this
  before_filter :require_admin, :except => [:index, :show] 

  # GET /application_materials
  # GET application_materials_url
  def index
    # CHECK: what if session[:applicant_id] doesn't exist? 
    @application_materials = ApplicationMaterial.find(:all, :conditions => ["applicant_id = ?", session[:applicant_id]])
  end
  
  # GET /application_materials/1
  # GET application_material_url(:id => 1)
  def show
    @application_material = ApplicationMaterial.find(params[:id])
  end

  # GET /application_materials/new
  # Get new_application_material_url
  def new
    @application_material = ApplicationMaterial.new
  end

  # GET /application_materials/1/edit
  # GET edit_application_material_url(:id => 1)
  def edit
    @application_material = ApplicationMaterial.find(params[:id])
  end
  
  # POST /application_materials
  # POST application_materials_url
  def create
    @application_material = ApplicationMaterial.create(params[:application_material])
    
    # revise the following for when an applicant_id has not yet been set
    @application_material.applicant_id = session[:applicant_id]

    @application_material.save ? flash[:notice] = "\'#{@application_material.title}\' has been created." : flash.now[:error] = "\'#{@application_material.title}\' could not be created"
    redirect_to(application_materials_url)
  end

  # PUT /application_materials/1
  # PUT application_material_url(:id => 1)
  def update
    @application_material = ApplicationMaterial.find(params[:id])
    @application_material.update_attributes(params[:application_material]) ? flash[:notice] = "\'#{@application_material.title}\' has been updated." : flash[:error] = "\'#{@application_material.title}\' could not be updated."
    redirect_to(application_materials_url)
  end

  # DELETE /application_materials/1
  # DELETE application_material_url(:id => 1)
  def destroy
    @application_material = ApplicationMaterial.find(params[:id])
    @application_material.destroy ? flash[:notice] = "\'#{@application_material.title}\' has been deleted." : flash[:error] = "Error: \'#{@application_material.title}\' could not be deleted."
    redirect_to(application_materials_url)
  end
end
