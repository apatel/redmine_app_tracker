class JobApplicationMaterial < ActiveRecord::Base
  unloadable
  # TODO implement saving of files using Redmine's Attachment model 
  
  # associations
  belongs_to :job_application
  acts_as_attachable

  # TODO implement validation 

  # constants
  # TODO convert these values into variables that can be set from a settings page within Redmine
  MATERIAL_TYPE = ['Resume', 'Cover Letter', 'School Transcript', 'Recommendation Letter', 'License Photocopy', 'Passport Photocopy', 'Other']

  # save an application file 
  # TODO correct storage path
  # TODO serialize filename
  # TODO Provide warning before overwriting of a file with the same name
  # TODO Sanitize filename
  def self.save_file(application_file)
    storage_directory = "#{RAILS_ROOT}/vendor/plugins/#{Apptracker::APPTRACKER_PLUGIN_FOLDER}/assets/applicant_files"
    applicant_filename =  application_file[:data].original_filename
    path = File.join(storage_directory, applicant_filename)
    File.open(path, "wb") { |f| f.write(application_file[:data].read) }
  end
end
