class Referrer < ActiveRecord::Base
  unloadable

  # associations
  belongs_to :applicant

  # validations

  # constants
  REFERENCE_STATUS = ['Unsubmitted', 'Submitted']

end
