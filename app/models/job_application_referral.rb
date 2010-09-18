class JobApplicationReferral < ActiveRecord::Base
  unloadable

  # associations
  belongs_to :job_application

  # validations
  validates_presence_of :first_name, :last_name, :email, :notes

  # constants

end
