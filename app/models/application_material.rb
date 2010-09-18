class ApplicationMaterial < ActiveRecord::Base
  # TODO PHASE OUT THIS MODEL
 
  # associations
  belongs_to :applicant
  acts_as_attachable

  # validation 

  # constants
  MATERIAL_TYPE = ['Resume', 'Cover Letter', 'School Transcript', 'Recommendation Letter', 'License Photocopy', 'Passport Photocopy', 'Other']

  # save an application file 
  def self.save_file(application_file)
    storage_directory = "#{RAILS_ROOT}/vendor/plugins/#{Apptracker::APPTRACKER_PLUGIN_FOLDER}/assets/applicant_files"
    applicant_filename =  application_file[:data].original_filename
    path = File.join(storage_directory, applicant_filename)
    File.open(path, "wb") { |f| f.write(application_file[:data].read) }
  end


end
