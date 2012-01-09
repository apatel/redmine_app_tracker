class JobApplicationCustomField < CustomField
  unloadable

  # associations
  #belongs_to :job_application
  #belongs_to :job
  #has_and_belongs_to_many :job_applications, :join_table => "#{table_name_prefix}custom_fields_job_applications#{table_name_suffix}", :foreign_key => "custom_field_id"
  has_and_belongs_to_many :jobs, :join_table => "#{table_name_prefix}custom_fields_jobs#{table_name_suffix}", :foreign_key => "custom_field_id"
  has_many :job_appications, :through => :job_application_custom_values

end
