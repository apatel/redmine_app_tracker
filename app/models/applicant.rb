class Applicant < ActiveRecord::Base
  
  # associations
  has_and_belongs_to_many :apptrackers
  has_many :projects, :through => :apptrackers

  has_many :job_application_materials, :through => :job_applications
  has_many :job_application_referrals, :through => :job_applications
  has_many :job_applications, :dependent => :destroy
  
  acts_as_searchable :columns => ["#{table_name}.user_name", "#{table_name}.first_name", "#{table_name}.last_name"], :order_column => "created_at", :date_column => :created_at
  acts_as_event :title => Proc.new {|o| "#{o.user_name}"},
                :url => Proc.new {|o| {:controller => 'applicants', :action => 'show', :id => o.id}},
                :type => Proc.new {|o| 'applicant' },
                :datetime => :created_at
                
  acts_as_activity_provider :find_options => {:select => "#{Applicant.table_name}.*", 
                                              :joins => "LEFT JOIN #{JobApplication.table_name} ON #{Applicant.table_name}.id=#{JobApplication.table_name}.applicant_id"}           

  # FIXME uncomment this when starting to implement Redmine login functionality
  # belongs_to :user


  # validation
  # FIXME Validations that fail are coming up with a 'translation missing: en' error
  validates_presence_of :first_name, :message => "First Name can not be empty."
  validates_presence_of :last_name, :message => "Last Name can not be empty."
  validates_presence_of :user_name, :message => "User Name can not be empty."
  validates_presence_of :email, :message => "Email can not be empty."
  validates_presence_of :address_1, :message => "Address 1 can not be empty."
  validates_presence_of :city, :message => "City can not be empty."
  validates_presence_of :state, :message => "State/Province can not be empty."
  validates_presence_of :postal_code, :message => "Postal Code can not be empty."
  validates_presence_of :country, :message => "Country can not be empty."
  validates_presence_of :phone, :message => "Phone can not be empty."

  # TODO validate uniqueness of login name once plugin is integrated into Redmine's user login/authentication
  # validates_uniqueness_of :user_name

  # constants
  # TODO convert these values into variables that can be set from a settings page within Redmine
  GENDER_OPTIONS = ['Male', 'Female', 'Other/Prefer not to answer']
  HIGHEST_DEGREE_LEVEL = ['High school', 'Technical', 'Associate', 'Bachelor', 'Graduate', 'PhD', 'MD', 'Other']

end
