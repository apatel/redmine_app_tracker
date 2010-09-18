class Job < ActiveRecord::Base
  # associations
  belongs_to :apptracker
  # FIXME Should job_applications to a job be destroyed if a job is deleted?
  # has_many :job_applications, :dependent => :destroy
  has_many :job_applications
  has_many :applicants, :through => :job_applications
  has_many :job_custom_fields, :dependent => :destroy
  has_many :job_attachments, :dependent => :destroy

  # TODO add :reject_if code
  accepts_nested_attributes_for :job_custom_fields, :allow_destroy => true
  accepts_nested_attributes_for :job_attachments, :allow_destroy => true

  # validation
  validates_presence_of :category, :status, :title, :description
  # validates_uniqueness_of :title
  
  # constants
  # TODO convert these values into variables that can be set from a settings page within Redmine
  # The first entry of the JOB_STATUS array is reserved for allowing anonymous to see a job's details
  JOB_STATUS = ["Active", "Inactive", "Filled"]
  JOB_CATEGORIES = ["Internship", "Fellowship", "Program", "Staff"]

end
