class Job < ActiveRecord::Base
  # associations
  belongs_to :apptracker
  
  # FIXME Should job_applications to a job be destroyed if a job is deleted?
  has_many :job_applications
  has_many :applicants, :through => :job_applications
  has_many :job_attachments, :dependent => :destroy

  has_and_belongs_to_many :job_application_custom_fields,
                          :class_name => 'JobApplicationCustomField',
                          :order => "#{CustomField.table_name}.position",
                          :join_table => "#{table_name_prefix}custom_fields_jobs#{table_name_suffix}",
                          :association_foreign_key => 'custom_field_id'
       
  acts_as_searchable :columns => ["#{table_name}.title", "#{table_name}.description"], :date_column => :created_at
  acts_as_event :title => Proc.new {|o| "#{o.title}"},
                :url => Proc.new {|o| {:controller => 'jobs', :action => 'show', :id => o.id}},
                :type => Proc.new {|o| 'job' },
                :datetime => :created_at
                        
  acts_as_customizable
  acts_as_attachable :delete_permission => :manage_documents
 
  # TODO if necessary, modify :reject_if code for more advanaced error checking
  #accepts_nested_attributes_for :job_custom_fields, :allow_destroy => true
  
  #accepts_nested_attributes_for :job_application_custom_fields, :allow_destroy => true
  accepts_nested_attributes_for :job_attachments, :reject_if => proc { |attributes| attributes['document'].blank? }, :allow_destroy => true

  # validation
  validates_presence_of :category, :status, :title, :short_desc, :description, :referrer_count, :application_followup_message
  validates_length_of :short_desc, :maximum => 255
  
  # constants
  # TODO convert these values into variables that can be set from a settings page within Redmine
  # The first entry of the JOB_STATUS array is reserved for allowing anonymous to see a job's details
  JOB_STATUS = ["Active", "Inactive", "Filled"]
  JOB_CATEGORIES = ["Internship", "Fellowship", "Program", "Staff"]
  JOB_MATERIALS = ["Resume or CV", "Cover Letter", "Proposed Work", "Writing Sample"]
  
  def all_job_app_custom_fields
    @all_job_app_custom_fields = self.job_application_custom_fields
  end

end
