class Job < ActiveRecord::Base
  # associations
  belongs_to :apptracker
  # has_many :job_applications, :through => :applicants

  # validation
  
end
