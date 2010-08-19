class ApplicationMaterialsController < ApplicationController
  unloadable # don't keep reloading this
  # before_filter :require_admin, :except => [:index, :show] 
  
  # GET /application_materials
  # GET application_materials_url
  # view application materials from an administrative scope
  def index

    @application_materials = ApplicationMaterial.find(:all, 
                            :conditions => ["applicant_id = ? AND apptracker_id = ?", 
                            session[:user_id], session[:apptracker_id]])
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
    if(!params[:application_file].nil?)
      attempt_save = ApplicationMaterial.save_file(params[:application_file])
      if(attempt_save)
        @application_material = ApplicationMaterial.create(params[:application_material])
        @application_material.applicant_id = session[:user_id]
        @application_material.apptracker_id = session[:apptracker_id]
        @application_material.filename = params[:application_file][:data].original_filename
        @application_material.save
      else
        flash[:error] = "There was an error during file upload. Please try gain, and if the problem persists, please contact the system admin."
      end
      redirect_to(application_materials_url)
    else 
      flash[:error] = "No file added. Please try uploading again."
      redirect_to(new_application_material_url)
    end
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
    @application_material.destroy ? flash[:notice] = "\'#{@application_material.filename}\' has been deleted." : flash[:error] = "Error: \'#{@application_material.filename}\' could not be deleted."
    redirect_to(application_materials_url)
  end
 
  # TODO Add RESTful resource route to routes.rb 
  # download an application file
  def download
    application_file = ApplicationMaterial.find(params[:id])
    storage_directory = "#{RAILS_ROOT}/vendor/plugins/#{Apptracker::APPTRACKER_PLUGIN_FOLDER}/assets/applicant_files"
    #TODO Check if the Berkman Apache server can make use of the :x_sendfile option
    if(application_file.filename)
      send_file("#{storage_directory}/#{application_file.filename}")
    end
  end

end
