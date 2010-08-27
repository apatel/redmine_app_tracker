class ApplicantsController < ApplicationController
  unloadable # don't keep reloading this
  # TODO figure out a better way of accessing the parent apptracker via association
  #before_filter :require_admin, :except => ['index', 'show']
  before_filter :require_admin

  # GET /applicants
  # GET applicants_url
  # show listing of all applicants maintained by a single apptracker 
  def index
    # take advantage of model associations for finding applicants
    @apptracker = Apptracker.find(session[:apptracker_id])
    @applicants = @apptracker.applicants

    # no applicant is selected, sesssion should reflect this
    session[:applicant_id] = nil
  end
  
  # GET /applicants/1
  # GET applicant_url(:id => 1)
  # show an apptlicant's info
  def show 
    @apptracker = Apptracker.find(session[:apptracker_id])
    @applicant = @apptracker.applicants.find(params[:id])
    
    @application_materials = @applicant.application_materials
    # TODO enable the following variables after referrer and job_applications are implemented
    @referrers = @applicant.referrers
    #@job_application = @applicant.job_applications
     
    # update session info
    session[:applicant_id] = @applicant.id
    session[:apptracker_id] = @applicant.apptracker_id

    respond_to do |format|
      format.html #show.html.erb
    end
  end

  # GET /applicants/new
  # Get new_applicant_url
  def new
    # make a new applicant
    @apptracker = Apptracker.find(session[:apptracker_id])
    @applicant = @apptracker.applicants.new

    respond_to do |format|
      format.html #new.html.erb
    end
  end

  # GET /applicants/1/edit
  # GET edit_applicant_url(:id => 1)
  def edit
    # find the applicant for editing
    @apptracker = Apptracker.find(session[:apptracker_id]) 
    @applicant = @apptracker.applicants.find(params[:id])
  end
  
  # POST /applicants
  # POST applicants_url
  def create
    # create an applicant and attach it to its parent apptracker
    @apptracker = Apptracker.find(session[:apptracker_id])
    @applicant = @apptracker.applicants.new(params[:applicant])

    # attempt to save, and flash the result to the user
    respond_to do |format|
      if(@applicant.save)
        # no errors, redirect with success message
        format.html { redirect_to(@applicant, :notice => "#{@applicant.first_name} #{@applicant.last_name}\'s record has been created.") }
      else
        # validation prevented save
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /applicants/1
  # PUT applicant_url(:id => 1)
  def update
    # find the applicant via its parent apptracker
    @apptracker = Apptracker.find(session[:apptracker_id])
    @applicant = @apptracker.applicants.find(params[:id])

    # attempt to update attributes, and flash the result to the user
    respond_to do |format|
      if(@applicant.update_attributes(params[:applicant]))
        # successfully updated; redirect and indicate success to user
        format.html{ redirect_to(applicants_url, :notice => "#{@applicant.first_name} #{@applicant.last_name}\'s record has been updated.")}
      else
        # update failed; go back to edit form
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /applicants/1
  # DELETE applicant_url(:id => 1)
  def destroy
    # find the applicant via its parent apptracker
    @apptracker = Apptracker.find(session[:apptracker_id])
    @applicant = @apptracker.applicants.find(params[:id])

    # attempt to destroy the applicant (ouch), and flash the result to the user
    @applicant.destroy ? flash[:notice] = "#{@applicant.first_name} #{@applicant.last_name}\'s record has been deleted." : flash[:error] = "Error: #{@applicant.first_name} #{@applicant.last_name}\'s record could not be deleted."
    
    respond_to do |format|
      format.html { redirect_to(applicants_url) }
    end
  end
end
