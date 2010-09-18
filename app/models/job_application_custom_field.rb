class JobApplicationCustomField < ActiveRecord::Base
  unloadable

  # associations
  belongs_to :job_application

  # validations
  validates_presence_of :name
  validates_uniqueness_of :name

  # constants

end
