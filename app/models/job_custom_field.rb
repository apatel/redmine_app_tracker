class JobCustomField < CustomField
  unloadable

  # associations
  #has_and_belongs_to_many :jobs, :join_table => "#{table_name_prefix}custom_fields_jobs#{table_name_suffix}", :foreign_key => "custom_field_id"

  # validations
#  validates_presence_of :name, :field_type, :validation_text
#  validates_uniqueness_of :name

  # constants
  
  acts_as_customizable

end
