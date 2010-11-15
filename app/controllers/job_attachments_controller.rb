# TODO Implement this controller
class JobAttachmentsController < ApplicationController
  model_object JobAttachment
  default_search_scope :documents
  before_filter :find_project, :only => [:index, :new]
  before_filter :find_model_object, :except => [:index, :new]
  before_filter :find_project_from_association, :except => [:index, :new]

  helper :attachments
  include AttachmentsHelper

  def index
    
  end

  def show
  end

  def new
    @job_attachment = Job.find(params[:id]).job_attachments.build(params[:job_attachment])
    if request.post? and @job_attachment.save 
      attachments = Attachment.attach_files(@job_attachment, params[:attachments])
      render_attachment_warning_if_needed(@job_attachment)
      flash[:notice] = l(:notice_successful_create)
      redirect_to :action => 'index', :project_id => @job_attachment
    end
#    @job = Job.find(params[:id])
#    @apptracker = Apptracker.find(params[:apptracker_id])
end

def add_attachment
    attachments = Attachment.attach_files(@job_attachment, params[:attachments])
    render_attachment_warning_if_needed(@job_attachment)

    Mailer.deliver_attachments_added(attachments[:files]) if attachments.present? && attachments[:files].present? && Setting.notified_events.include?('document_added')
    redirect_to :action => 'show', :id => @job_attachment
  end

  def create
    # create an attachment in its parent job
    @job = Job.find(params[:job_id])
    if(params[:form][:form_id].to_i == 2)
      @job_attachment = @job.job_attachment.new(params[:job_attachment])
    else
      @job_attachment = @job.job_attachment.find(params[:job_attachment_id])
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
