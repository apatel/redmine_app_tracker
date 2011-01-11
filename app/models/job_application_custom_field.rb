class JobApplicationCustomField < ActiveRecord::Base
  unloadable

  # associations
  #belongs_to :job_application
  #belongs_to :job
  #has_and_belongs_to_many :job_applications, :join_table => "#{table_name_prefix}custom_fields_job_applications#{table_name_suffix}", :foreign_key => "custom_field_id"
  has_and_belongs_to_many :jobs, :join_table => "#{table_name_prefix}custom_fields_jobs#{table_name_suffix}", :foreign_key => "custom_field_id"
  # validations
  #validates_presence_of :name
  #validates_uniqueness_of :name

  # constants

end
