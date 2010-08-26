class JobApplication < ActiveRecord::Base
  unloadable

  # associations
  belongs_to :applicant

  # TODO check the following associations
  has_many :referrers, :through => :applicant
  has_many :application_materials, :through => :applicant

  # validations

  # constants
  APPLICATION_STATUS = ['unsubmitted','submitted', 'accepted', 'rejected']
end
