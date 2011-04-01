require 'rubygems'
require 'zip/zipfilesystem'

class JobApplicationMaterial < ActiveRecord::Base
  unloadable
  
  # associations
  belongs_to :job_application
  acts_as_attachable

  validates_presence_of :job_application_id

  # TODO implement validation 

  # constants
  # TODO convert these values into variables that can be set from a settings page within Redmine
  MATERIAL_TYPE = ['Resume', 'Cover Letter', 'School Transcript', 'Recommendation Letter', 'License Photocopy', 'Passport Photocopy', 'Other']


  def attachments_deletable?(usr=User.current)
    #editable_by?(usr) && super(usr)
    true
  end
  
  def project
    self.job_application.job.apptracker.project
  end
  
  def visible?(user=User.current)
    #!user.nil? && user.allowed_to?(:view_documents, project)
    true
  end
  
  def attachments_visible?(user=User.current)
    #user.allowed_to?(self.class.attachable_options[:view_permission], self.project)
    true
  end
  
  # save an application file 
  # TODO correct storage path
  # TODO serialize filename
  # TODO Provide warning before overwriting of a file with the same name
  # TODO Sanitize filename
#  def self.save_file(application_file)
#    storage_directory = "#{RAILS_ROOT}/vendor/plugins/#{Apptracker::APPTRACKER_PLUGIN_FOLDER}/assets/applicant_files"
#    applicant_filename =  application_file[:data].original_filename
#    path = File.join(storage_directory, applicant_filename)
#    File.open(path, "wb") { |f| f.write(application_file[:data].read) }
#  end
  
end
