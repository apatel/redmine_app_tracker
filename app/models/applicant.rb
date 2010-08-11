class Applicant < ActiveRecord::Base
  # associations
  belongs_to :apptracker
  has_many :application_materials, :dependent => :destroy
  # has_many :referrers, :dependent => :destroy
  # has_many :job_applications, :dependent => :destroy

  # validation

end
