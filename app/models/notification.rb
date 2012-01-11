class Notification < Mailer
  
  def application_submitted(job_application)
    # Send the email to the applicant
    @message = job_application.job.application_followup_message
    recipients Applicant.find_by_id(job_application.applicant_id).email
    subject "Application Submitted"
    body :user => Applicant.find_by_id(job_application.applicant_id),
         :url => url_for(:controller => 'job_application', :action => 'show', :id => job_application.id, :apptracker_id => job_application.apptracker_id)
    content_type "text/html"     
  end
  
  def application_updated(job_application)
    # Send the email to the applicant
    recipients Applicant.find_by_id(job_application.applicant_id).email
    subject "Application Updated"
    body :user => Applicant.find_by_id(job_application.applicant_id),
         :url => url_for(:controller => 'job_application', :action => 'show', :id => job_application.id, :apptracker_id => job_application.apptracker_id)
    content_type "text/html"
  end
  
  def request_referral(job_application, email)
    @job_application = job_application
    # Send email to referrer
    recipients email
    subject "Referral Request"
    body :user => Applicant.find_by_id(job_application.applicant_id),
         :url => url_for(:controller => 'job_application', :action => 'show', :id => job_application.id, :apptracker_id => job_application.apptracker_id)
    content_type "text/html"     
  end
  
  def referral_complete(job_application, referrer_email)
    # Send the email to the applicant
    emails = referrer_email + "," + Applicant.find_by_id(job_application.applicant_id).email
    recipients emails
    subject "Referral Complete"
    body :user => Applicant.find_by_id(job_application.applicant_id),
         :url => url_for(:controller => 'job_application', :action => 'show', :id => job_application.id, :apptracker_id => job_application.apptracker_id)
    content_type "text/html"     
  end
  
end