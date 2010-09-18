class JobCustomField < ActiveRecord::Base
  unloadable

  # associations
  belongs_to :job

  # validations
  validates_presence_of :name, :field_type, :validation_text
  validates_uniqueness_of :name

  # constants

end
