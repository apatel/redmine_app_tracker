class ApplicantsController < ApplicationController
  unloadable # don't keep reloading this
  # before_filter :require_admin, :except => [:index, :show] 

  # GET /applicants
  # GET applicants_url
  def index
    @applicants = Applicant.find(:all, :conditions => ["apptracker_id = ?", session[:apptracker_id]])

    # no applicant is selected, sesssion should reflect this
    session[:applicant_id] = nil
  end
  
  # GET /applicants/1
  # GET applicant_url(:id => 1)
  def show
    @applicant = Applicant.find(params[:id])

    # update session info
    session[:applicant_id] = @applicant.id
    session[:apptracker_id] = @applicant.apptracker_id
  end

  # GET /applicants/new
  # Get new_applicant_url
  def new
    @applicant = Applicant.new
  end

  # GET /applicants/1/edit
  # GET edit_applicant_url(:id => 1)
  def edit
    @applicant = Applicant.find(params[:id])
  end
  
  # POST /applicants
  # POST applicants_url
  def create
    @applicant = Applicant.create(params[:applicant])

    # associate the applicant with its parent apptracker
    @applicant.apptracker_id = session[:apptracker_id]
    
    # attempt to save, and flash the result to the user
    @applicant.save ? flash[:notice] = "#{@applicant.first_name} #{@applicant.last_name}\'s record has been created." : flash.now[:error] = "#{@applicant.first_name} #{@applicant.last_name}\'s record could not be created"

    redirect_to(applicants_url)
  end

  # PUT /applicants/1
  # PUT applicant_url(:id => 1)
  def update
    @applicant = Applicant.find(params[:id])

    # attempt to update attributes, and flash the result to the user
    @applicant.update_attributes(params[:applicant]) ? flash[:notice] = "#{@applicant.first_name} #{@applicant.last_name}\'s record has been updated." : flash[:error] = "#{@applicant.first_name} #{@applicant.last_name}\'s record could not be updated."

    redirect_to(applicants_url)
  end

  # DELETE /applicants/1
  # DELETE applicant_url(:id => 1)
  def destroy
    @applicant = Applicant.find(params[:id])

    # attempt to destroy the applicant (ouch), and flash the result to the user
    @applicant.destroy ? flash[:notice] = "#{@applicant.first_name} #{@applicant.last_name}\'s record has been deleted." : flash[:error] = "Error: #{@applicant.first_name} #{@applicant.last_name}\'s record could not be deleted."

    redirect_to(applicants_url)
  end 
end
