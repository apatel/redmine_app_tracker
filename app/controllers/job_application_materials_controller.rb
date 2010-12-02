# TODO implemente this controller
class JobApplicationMaterialsController < ApplicationController
  unloadable

  def index
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
