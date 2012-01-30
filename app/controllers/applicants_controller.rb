require 'carmen'
include Carmen

class ApplicantsController < ApplicationController
  unloadable # don't keep reloading this
  #before_filter :require_admin, :except => ['index', 'show']
  #before_filter :require_admin

  default_search_scope :applicants
  
  helper :sort
  include SortHelper

  # GET /applicants
  # GET applicants_url
  # show listing of all applicants associated with a single apptracker
  # FIXME Update this to reflect join condition with the Apptracker Model
  def index
    sort_init 'last_name', 'asc'
    sort_update %w(first_name last_name user_name)
    
    @apptracker = Apptracker.find(params[:apptracker_id])
    @applicants = Applicant.find(:all, :order => sort_clause)
  end
  
  # GET /applicants/1
  # GET applicant_url(:id => 1)
  # show an applicant's info
  def show 
    @apptracker = Apptracker.find(params[:apptracker_id])
    @applicant = Applicant.find(params[:id])
	unless User.current.admin? || @applicant.email == User.current.mail
		redirect_to('/') and return
	end
    # TODO uncomment this after job applications are implemented
    # @job_applications = @applicant.job_applications

    respond_to do |format|
      format.html #show.html.erb
    end
  end
  
  def country_select
    begin
       country = Carmen::country_code(params[:id])
       @states = Carmen::states(country)
    rescue
       @states = nil
    end
    render :partial => "states"
  end

  # GET /applicants/new
  # Get new_applicant_url
  def new
    # make a new applicant
    @apptracker = Apptracker.find(params[:apptracker_id])
    unless params[:job_id].nil?
      @job = Job.find(params[:job_id])
    end  
    @user = User.current
    @applicant = @apptracker.applicants.new

    respond_to do |format|
      format.html #new.html.erb
    end
  end

  # GET /applicants/1/edit
  # GET edit_applicant_url(:id => 1)
  def edit
    # find the applicant for editing
    @apptracker = Apptracker.find(params[:apptracker_id]) 
    @applicant = Applicant.find(params[:id])
    @user = User.current
	unless User.current.admin? || @applicant.email == User.current.mail
		redirect_to('/') and return
	end
  end
  
  # POST /applicants
  # POST applicants_url
  def create
  	#TODO - probably need to verify a user can't submit applications
	# under another's account --DJCP

    # create an applicant and attach it to its parent apptracker
    @apptracker = Apptracker.find(params[:apptracker_id])
    @applicant = @apptracker.applicants.new(params[:applicant])
    unless params[:job_id].nil?
      @job = Job.find(params[:job_id])
    end
    @user = User.current 
    
    # attempt to save, and flash the result to the user
    respond_to do |format|
      if(@applicant.save)
        debugger
        # no errors, redirect with success message
        unless @job.nil?
          format.html { redirect_to(new_job_application_url(:apptracker_id => @apptracker.id, :job_id => @job.id, :user_id => User.current.id)) }
        else
          format.html { redirect_to(applicant_url(@applicant, :apptracker_id => @apptracker.id)) }
        end    
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
    @apptracker = Apptracker.find(params[:apptracker_id])
    params[:applicant].delete(:apptracker_id)
    @applicant = Applicant.find(params[:id])
    @user = User.current

	unless User.current.admin? || @applicant.email == User.current.mail
		redirect_to('/') and return
	end
    
    # attempt to update attributes, and flash the result to the user
    respond_to do |format|
      if(@applicant.update_attributes(params[:applicant]))
        # successfully updated; redirect and indicate success to user
        format.html{ redirect_to(applicant_url(@applicant,:apptracker_id => @apptracker.id, :notice => "#{@applicant.first_name} #{@applicant.last_name}\'s record has been updated."))}
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
    @apptracker = Apptracker.find(params[:apptracker_id])
    @applicant = Applicant.find(params[:id])

	unless User.current.admin? || @applicant.email == User.current.mail
		redirect_to('/') and return
	end

    # attempt to destroy the applicant (ouch), and flash the result to the user
    @applicant.destroy ? flash[:notice] = "#{@applicant.first_name} #{@applicant.last_name}\'s record has been deleted." : flash[:error] = "Error: #{@applicant.first_name} #{@applicant.last_name}\'s record could not be deleted."
    
    respond_to do |format|
      format.html { redirect_to(applicants_url(:apptracker_id => @apptracker.id)) }
    end
  end
end
