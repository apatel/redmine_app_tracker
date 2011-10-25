require 'rubygems'
require 'zip/zipfilesystem'

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
        unless params[:zipped_file].nil?
          @zipped_file = params[:zipped_file]
        end
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

  def zip_files
    @files = params[:files]
    @ja_materials = []
    @files.each do |f|
      @ja_materials << JobApplicationMaterial.find(f)
    end
    filepaths = []
    @ja_materials.each do |jam|
      jam.attachments.each do |jama|
        filepaths << "#{RAILS_ROOT}/files/" + jama.disk_filename
      end  
    end  
    zip("#{RAILS_ROOT}/files/jam.zip", filepaths)
    @zipped_file = "#{RAILS_ROOT}/files/jam.zip"
    p "zipped"
    p @zipped_file
    redirect_to :action => 'index', :apptracker_id => params[:apptracker_id], :zipped_file => @zipped_file
  end
  
  def zip(zip_file_path, list_of_file_paths)

    @zip_file_path = zip_file_path
    list_of_file_paths = [list_of_file_paths] if list_of_file_paths.class == String
    @list_of_file_paths = list_of_file_paths

    Zip::ZipFile.open(@zip_file_path, Zip::ZipFile::CREATE) do |zipfile|
      @list_of_file_paths.each do | file_path |
        if File.exists?file_path
          file_name = File.basename( file_path )
          if zipfile.find_entry( file_name )
            zipfile.replace( file_name, file_path )
          else
            zipfile.add( file_name, file_path)
          end
        else
          puts "Warning: file #{file_path} does not exist"
        end
      end
    end
  end
end
