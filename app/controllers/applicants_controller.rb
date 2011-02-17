class ApplicantsController < ApplicationController
  unloadable # don't keep reloading this
  #before_filter :require_admin, :except => ['index', 'show']
  #before_filter :require_admin

  # GET /applicants
  # GET applicants_url
  # show listing of all applicants associated with a single apptracker
  # FIXME Update this to reflect join condition with the Apptracker Model
  def index
    @apptracker = Apptracker.find(params[:apptracker_id])
    @applicants = Applicant.all
  end
  
  # GET /applicants/1
  # GET applicant_url(:id => 1)
  # show an applicant's info
  def show 
    @apptracker = Apptracker.find(params[:apptracker_id])
    @applicant = Applicant.find(params[:id])

    # TODO uncomment this after job applications are implemented
    # @job_applications = @applicant.job_applications

    respond_to do |format|
      format.html #show.html.erb
    end
  end

  # GET /applicants/new
  # Get new_applicant_url
  def new
    # make a new applicant
    @apptracker = Apptracker.find(params[:apptracker_id])
    @job_id = params[:job_id]
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
  end
  
  # POST /applicants
  # POST applicants_url
  def create
    # create an applicant and attach it to its parent apptracker
    @apptracker = Apptracker.find(params[:applicant][:apptracker_id])
    params[:applicant].delete(:apptracker_id)
    p params[:applicant]
    @applicant = @apptracker.applicants.new(params[:applicant])

    # attempt to save, and flash the result to the user
    respond_to do |format|
      if(@applicant.save)
        debugger
        # no errors, redirect with success message
        format.html { redirect_to(applicants_url(:apptracker_id => @apptracker.id, :job_id => params[:applicant][:job_id])) }
        #format.html { redirect_to(applicants_url(:apptracker_id => @apptracker.id), :notice => "#{@applicant.first_name} #{@applicant.last_name}\'s record has been created.") }
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
    @apptracker = Apptracker.find(params[:applicant][:apptracker_id])
    @applicant = @apptracker.applicants.find(params[:id])

    # attempt to update attributes, and flash the result to the user
    respond_to do |format|
      if(@applicant.update_attributes(params[:applicant]))
        # successfully updated; redirect and indicate success to user
        format.html{ redirect_to(applicants_url, :apptracker_id => @apptracker.id, :notice => "#{@applicant.first_name} #{@applicant.last_name}\'s record has been updated.")}
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
    @applicant = @apptracker.applicants.find(params[:id])

    # attempt to destroy the applicant (ouch), and flash the result to the user
    @applicant.destroy ? flash[:notice] = "#{@applicant.first_name} #{@applicant.last_name}\'s record has been deleted." : flash[:error] = "Error: #{@applicant.first_name} #{@applicant.last_name}\'s record could not be deleted."
    
    respond_to do |format|
      format.html { redirect_to(applicants_url) }
    end
  end
end
