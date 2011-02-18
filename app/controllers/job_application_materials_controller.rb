# TODO implemente this controller
class JobApplicationMaterialsController < ApplicationController
  unloadable
  
  helper :attachments
  include AttachmentsHelper

  def index
    @apptracker = Apptracker.find(params[:apptracker_id])
    if(User.current.admin?)
      if(params[:view_scope] == 'job' || (params[:applicant_id].nil? && params[:apptracker_id].nil?))
        # if viewing all job applications for a particular job
        @job_application_materials = Job.find(params[:job_id]).job_application.job_application_materials
      elsif(params[:view_scope] == 'applicant' || (params[:job_id].nil? && params[:apptracker_id].nil?))
        # if viewing all job applications for a particular user/applicant
        @job_application_materials = Applicant.find(params[:applicant_id]).job_application.job_application_materials
      else
        # if viewing all job applications for an apptracker
        @jobs = Apptracker.find(params[:apptracker_id]).jobs
        @job_application_material = Array.new
        @jobs.each do |job|
          job.job_applications.each do |ja|
            @job_application_material << ja.job_application_materials
          end
        end
      end
      @job_application_material.flatten!

    elsif(User.current.logged?)
      @applicant = Applicant.find_by_email(User.current.mail)
      @job_applications = @applicant.job_applications
      @job_application_material = Array.new
      
      @job_applications.each do |ja|
        @job_application_material << ja.job_application_materials.find(:first, :include => [:attachments])
      end

      #@apptracker = Apptracker.find(params[:apptracker_id])
    end
  end

  def show
  end

  def new
    @job_application_material = JobApplication.find(params[:id]).job_application_materials.build(params[:job_application_material])
    if request.post? and @job_application_material.save 
      attachments = Attachment.attach_files(@job_application_material, params[:attachments])
      render_attachment_warning_if_needed(@job_application_material)
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'index', :project_id => @job_application_material
    end
  end
  
  def add_attachment
    attachments = Attachment.attach_files(@job_application_material, params[:attachments])
    render_attachment_warning_if_needed(@job_application_material)

    Mailer.deliver_attachments_added(attachments[:files]) if attachments.present? && attachments[:files].present? && Setting.notified_events.include?('document_added')
    redirect_to :action => 'show', :id => @job_application_material
  end  

  def create
    # create an attachment in its parent job
    @job_application = JobApplication.find(params[:job_application_id])
    @job_application_material = @job_application.job_application_material.find(params[:job_application_material_id])    
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
