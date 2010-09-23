class Applicant < ActiveRecord::Base
  
  # associations
  has_and_belongs_to_many :apptrackers

  has_many :job_application_materials, :through => :job_applications
  has_many :job_application_referrals, :through => :job_applications
  has_many :job_applications, :dependent => :destroy

  # FIXME uncomment this when starting to implement Redmine login functionality
  # belongs_to :user


  # validation
  # FIXME Validations that fail are coming up with a 'translation missing: en' error
  validates_presence_of :first_name, :last_name, :user_name, :email, :mobile_phone, :dob, :gender,
                        :grad_month, :grad_year, :highest_degree_level, :gpa, :gpa_scale, :school_name, 
                        :school_town_city, :school_state_province, :school_country, :home_street_1, 
                        :home_town_city, :home_state_province, :home_postal_code, :home_country, :home_phone
  
  # TODO fix regex validation fields
  # validates_format_of :dob, 
  #                    :with => /\d{2}(\/)\d(\/)\d{4}/,
  #                    :message => "Please correct the format of your date of birth (MM/DD/YYYY)"
  # validates_format_of :gpa, :with => /(\d{1})(\.)(\d{2})/
  # validates_format_of :gpa_scale, :with => /(\d{1})(\.)(\d{1})/

  # TODO validate uniqueness of login name once plugin is integrated into Redmine's user login/authentication
  # validates_uniqueness_of :user_name

  # constants
  # TODO convert these values into variables that can be set from a settings page within Redmine
  GENDER_OPTIONS = ['Male', 'Female', 'Other/Prefer not to answer']
  HIGHEST_DEGREE_LEVEL = ['High school', 'Technical', 'Associate', 'Bachelor', 'Graduate', 'PhD', 'MD', 'Other']

end
