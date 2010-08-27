class ReferrersController < ApplicationController
  unloadable
  #before_filter :authorize, :except => [:index, :show]
  # TODO find out how to use authentication for allowing access to :new and :edit actions
  before_filter :require_admin, :except => [:index, :show, :new, :edit] 

  # GET /referrers
  # GET referrers_url
  def index
    # secure the parent apptracker id and find its referrers
    @apptracker = Apptracker.find(session[:apptracker_id])
    @applicant = @apptracker.applicants.find(session[:applicant_id])
    @referrers = @applicant.referrers
  
    # no referrer currently selected, session should reflect this
    session[:referrer_id] = nil
  end
  
  # GET /referrers/1
  # GET referrer_url(:id => 1)
  def show
    # secure the parent apptracker id and find requested referrer
    @referrer = Referrer.find(params[:id])
    @applicant = @referrer.applicant

    # indicate current referrer id and applicant id in the session
    session[:referrer_id] = @referrer.id
    session[:applicant_id] = @referrer.applicant.id

    respond_to do |format|
      format.html #show.html.erb
    end
  end

  # GET /referrers/new
  # Get new_referrer_url
  def new
    # secure the parent applicant id and create a new referrer
    @applicant = Applicant.find(session[:applicant_id])
    @referrer = @applicant.referrers.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /referrers/1/edit
  # GET edit_referrer_url(:id => 1)
  def edit
    @referrer = Referrer.find(params[:id]) 
  end

  # POST /referrers
  # POST referrers_url
  def create
    # create a referrer connected to its parent applicant
    @applicant = Applicant.find(session[:applicant_id])
    @referrer = @applicant.referrers.new(params[:referrer])
 
    respond_to do |format|
      if(@referrer.save)
        # no errors, redirect with success message
        format.html { redirect_to(@referrer, :notice => "#{@referrer.first_name} #{@referrer.last_name} has been added as a referrer.") }
      else
        # validation prevented save; redirect back to new.html.erb with error messages
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /referrers/1
  # PUT referrer_url(:id => 1)
  def update
    # find the referrer within its parent applicant
    #@applicant = Applicant.find(session[:applicant_id])
    #@referrer = @applicant.referrers.find(params[:id])
    @referrer = Referrer.find(params[:id])
    @applicant = @referrer.applicant

    # update the referrer's attributes, and indicate a message to the user opon success/failure
    respond_to do |format|
      if(@referrer.update_attributes(params[:referrer]))
        # no errors, redirect with success message
        format.html { redirect_to(@referrer.applicant, :notice => "#{@referrer.first_name} #{@referrer.last_name}\'s information has been updated.") }
      else
        # validation prevented update; redirect to edit form with error messages

      end
    end
  end

  # DELETE /referrers/1
  # DELETE referrer_url(:id => 1)
  def destroy
    # create a referrer in the context of its parent applicant
    @applicant = Applicant.find(session[:applicant_id])
    @referrer = @applicant.referrers.find(params[:id])

    # destroy the referrer, and indicate a message to the user upon success/failure
    @referrer.destroy ? flash[:notice] = "#{@referrer.first_name} #{@referrer.last_name}\'s record has been deleted." : flash[:error] = "Error: #{@referrer.first_name} #{@referrer.last_name}\'s record could not be deleted."
    
    respond_to do |format|
      format.html { redirect_to(referrers_url) }
    end
  end
end
