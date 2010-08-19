class ApplicationMaterial < ActiveRecord::Base
  #TODO implement saving of files using Redmine's Attachment model 
  
  # associations
  belongs_to :applicant
  belongs_to :apptracker

  # validation
  acts_as_attachable

  # save an application file 
  def self.save_file(application_file)
    storage_directory = "#{RAILS_ROOT}/vendor/plugins/#{Apptracker::APPTRACKER_PLUGIN_FOLDER}/assets/applicant_files"
    applicant_filename =  application_file[:data].original_filename
    path = File.join(storage_directory, applicant_filename)
    #TODO Prevent overwriting of a file with the same name
    File.open(path, "wb") { |f| f.write(application_file[:data].read) }
  end

  # clean up filename text (IE)

end
