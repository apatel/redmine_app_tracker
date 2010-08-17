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

  # download an application file
  def self.download_file(application_file_id)
    application_file = ApplicationMaterial.find(application_file_id)
    storage_directory = "#{RAILS_ROOT}/vendor/plugins/#{Apptracker::APPTRACKER_PLUGIN_FOLDER}/assets/applicant_files"
    #TODO Check if the Berkman Apache server can make use of the :x_sendfile option
    if(application_file.filename)
      send_file("#{storage_directory}/#{application_file.filename}")
    end
  end

  # clean up filename text (IE)

end
