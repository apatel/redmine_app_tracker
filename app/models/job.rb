class Job < ActiveRecord::Base
  # associations
  belongs_to :apptracker
  has_many :applicants, :through => :apptracker

  # TODO check this association
  has_many :job_applications, :through => :applicant

  # has_one :job_application_template #, :through => :applicants

  # validation
  validates_presence_of :category, :status, :title, :description
  validates_uniqueness_of :title
  
   # constants
  JOB_STATUS = ["Inactive", "Active", "Filled"]
  JOB_CATEGORIES = ["Internship", "Fellowship", "Program", "Staff"]

end
