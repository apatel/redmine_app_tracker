# TODO implement this controller
class JobApplicationReferralsController < ApplicationController
  unloadable
  
  helper :attachments
  include AttachmentsHelper


  def index
    @apptracker = Apptracker.find(params[:apptracker_id])
    if(User.current.admin?)
      if(params[:view_scope] == 'job' || (params[:applicant_id].nil? && params[:apptracker_id].nil?))
        # if viewing all job applications for a particular job
        @job_application_referrals = Job.find(params[:job_id]).job_application.job_application_referrals
      elsif(params[:view_scope] == 'applicant' || (params[:job_id].nil? && params[:apptracker_id].nil?))
        # if viewing all job referrals for a particular user/applicant
        @job_application_referrals = Applicant.find(params[:applicant_id]).job_application.job_application_referrals
      else
        # if viewing all job applications for an apptracker
        @jobs = Apptracker.find(params[:apptracker_id]).jobs
        @job_application_referral = Array.new
        @jobs.each do |job|
          job.job_applications.each do |ja|
            @job_application_referral << ja.job_application_referrals
          end
        end
      end
      @job_application_referral.flatten!

    elsif(User.current.logged?)
      @applicant = Applicant.find_by_email(User.current.mail)
      @job_applications = @applicant.job_applications
      @job_application_referral = Array.new
      
      @job_applications.each do |ja|
        @job_application_referral << ja.job_application_referrals.find(:all, :include => [:attachments])
      end
      @job_application_referral.flatten!
    end
  end

  def show
  end

  def new
    @job_application = JobApplication.find(params[:id])
    @applicant = @job_application.applicant_id
    @apptracker = @job_application.apptracker_id
    @job = @job_application.job_id
    @job_application_referral = @job_application.job_application_referrals.build()
  end

  def create
    @job_application = JobApplication.find(params[:job_application_referral][:job_application_id])
    params[:job_application_referral][:referral_text] = params[:attachments]["1"][:description]
    
    @job_application_referral = @job_application.job_application_referrals.build(params[:job_application_referral])
    @job_application_referral.save
    attachments = Attachment.attach_files(@job_application_referral, params[:attachments])
    render_attachment_warning_if_needed(@job_application_referral)
    
    # Send email to applicant and referrer that referral has been submitted
    Notification.deliver_referral_complete(@job_application, @job_application_referral.email)
    
    redirect_to :controller => 'jobs', :action => 'index', :apptracker_id => @job_application.apptracker_id
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def request_referral
    @job_application = JobApplication.find(params[:id])
    @emails = params[:email].split(',')
    #Send Notification to Referrer
    @emails.each do |email|
      Notification.deliver_request_referral(@job_application, email)
    end
    
    redirect_to(job_applications_url(:apptracker_id => @job_application.apptracker_id, :applicant_id => @job_application.applicant_id), :notice => "Referral request has been sent.")
  end
end
