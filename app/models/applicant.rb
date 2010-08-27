class Applicant < ActiveRecord::Base
  # associations
  # belongs_to :apptracker
  has_and_belongs_to_many :apptrackers

  has_many :application_materials, :dependent => :destroy
  has_many :referrers, :dependent => :destroy
  has_many :job_applications, :dependent => :destroy

  # validation
  validates_presence_of :first_name, :last_name, :user_name, :email, :mobile_phone, :dob, :gender,
                        :grad_month, :grad_year, :highest_degree_level, :school_name, :school_town_city,
                        :school_state_province, :school_country, :home_street_1, :home_town_city,
                        :home_state_province, :home_postal_code, :home_country, :home_phone
  
  # TODO fix regex fields
  # validates_format_of :dob, 
  #                    :with => /\d{2}(\/)\d(\/)\d{4}/,
  #                    :message => "Please correct the format of your date of birth (MM/DD/YYYY)"
  # validates_format_of :gpa, :with => /(\d{1})(\.)(\d{2})/
  # validates_format_of :gpa_scale, :with => /(\d{1})(\.)(\d{1})/
  #validates_uniqueness_of :user_name

  # constants
  GENDER_OPTIONS = ['Male', 'Female', 'Other/Prefer not to answer']
  HIGHEST_DEGREE_LEVEL = ['High school', 'Technical', 'Associate', 'Bachelor', 'Graduate', 'PhD', 'MD', 'Other']

end
