class AddTestData < ActiveRecord::Migration
  def self.up
    # TODO remove all references to my e-mail address
    # TODO remove my .gitignore reference to this file
    # TODO add filenames for files
    # delete all previous records
    JobApplicationMaterial.delete_all
    JobApplicationReferral.delete_all
    JobApplicationCustomField.delete_all
    JobApplication.delete_all
    JobCustomField.delete_all
    JobAttachment.delete_all
    Job.delete_all
    Applicant.delete_all
    Apptracker.delete_all

    Project.create(
      :name => "2011 Jobs",
      :description => "Job tracking for all of 2011.",
      :homepage => "",
      :is_public => true,
      :parent_id => nil,
      :identifier => "berkman2011",
      :status => 1,
      :lft => 1,
      :rgt => 2
    )

    Apptracker.create(
      :project_id => 1,
      :title => 'Summer 2011',
      :description => 'Jobs, Internships, and Fellowships for Summer, 2011.',
      :status => 'Active'
    )

    Apptracker.create(
      :project_id => 1,
      :title => 'Fall 2010',
      :description => 'Jobs and Fellowships for Fall, 2010',
      :status => 'Active'
    )

    Apptracker.create(
      :project_id => 2,
      :title => 'Berk Next Year',
      :description => 'Another Test Apptracker',
      :status => 'Active'
    )

    Job.create(
      :apptracker_id => 1,
      :category => 'Internship',
      :title => 'Starship Captain\'s Assistant',
      :description => 'Provide coffee to the captaion of the Galaxy class NCC-1701-D',
      :positions_available => 2,
      :application_followup_message => 'Thank you for applying to the Berkman Center.  Live long and prosper.',
      :application_material_count => 4,
      :application_material_types => ['resume','cv','writing_sample','academic_transcript'],
      :attachment_count => 2,
      #:attachment_ids => [3,12],
      :referrer_count => 2,
      :status => 'Active'
    )

    Job.create(
      :apptracker_id => 1,
      :category => 'Fellowship',
      :title => 'Interweb Designer',
      :description => 'Design new tubes for the Interweb.',
      :positions_available => 1, 
      :application_followup_message => 'Thank you for applying to the Berkman Center, and thank you for taking an interest in designing the new Interweb.',
      :application_material_count => 3,
      :application_material_types => ['resume','code_sample','code_sample'],
      :attachment_count => 1,
      #:attachment_ids => [15],
      :referrer_count => 1,
      :status => 'Filled'
    )

    Job.create(
      :apptracker_id => 1,
      :category => 'Fellowship',
      :title => 'Fibonacci Number Counter',
      :description => 'Start the process of infitesimally counting the Fibonacci numbers for podcast recording.',
      :positions_available => 1,
      :application_followup_message => 'Thank you for applying.  We hope you find greater purpose in life.',
      :application_material_count => 3,
      :application_material_types => ['resume','cv','academic_transcript'],
      :attachment_count => 2,
      #:attachment_ids => [10,11],
      :referrer_count => 2,
      :status => 'Inactive'
    )

    Job.create(
      :apptracker_id => 2,
      :category => 'Staff',
      :title => 'Window Washer',
      :description => 'Wash windows of XP, ME, Vista, and other various stains. Insurance will be provided for occasional crashes/accidents.',
      :positions_available => 1,
      :application_followup_message => 'Thank you for applying to the Berkman Center.  We will send you a complimentary \'Tux\' penguin as a thank you for your interest.',
      :application_material_count => 2,
      :application_material_types => ['resume','writing_sample'],
      :attachment_count => 1,
      #:attachment_ids => [4],
      :referrer_count => 2,
      :status => 'Active'
    )

#    JobAttachment.create(
#      :job_id => 1,
#      :filename => '',
#      :name => 'Job Description',
#      :notes => 'These are job notes'
#    )

#    JobAttachment.create(
#      :job_id => 1,
#      :filename => '',
#      :name => 'Sample Questionnaire',
#      :notes => 'Sample Questions ...'
#    )
#
#    JobAttachment.create(
#      :job_id => 2,
#      :filename => '',
#      :name => 'Job Description',
#      :notes => 'These are job notes'
#    )
#
#    JobCustomField.create(
#      :job_id => 1,
#      :name => 'Years of Work Experience',
#      :field_type => 'integer',
#      :field_value => '4',
#      :validation_text => ''
#    )
#
#    JobCustomField.create(
#      :job_id => 1,
#      :name => 'Mother\'s Maiden Name',
#      :field_type => 'string',
#      :field_value => 'Johannson',
#      :validation_text => ''
#    )
#
#    JobCustomField.create(
#      :job_id => 2,
#      :name => 'Years of Work Experience',
#      :field_type => 'integer',
#      :field_value => '6',
#      :validation_text => ''
#    )   
    
    JobApplicationMaterial.create(
      :job_application_id => 1,
      :material_type => 'Resume',
      :title => '2011_08_25 Resume',
      :notes => '',
      :filename => ''
    )

    JobApplicationMaterial.create(
      :job_application_id => 1,
      :material_type => 'Cover Letter',
      :title => 'Mah Covah Lettah',
      :notes => '',
      :filename => ''
    )

    JobApplicationMaterial.create(
      :job_application_id => 2,
      :material_type => 'License Photocopy',
      :title => 'License, Expiry 2011',
      :notes => '',
      :filename => ''
    )

    JobApplicationMaterial.create(
      :job_application_id => 3,
      :material_type => 'Passport Photocopy',
      :title => 'Canada Passport',
      :notes => '',
      :filename => ''
    )

    Applicant.create(
      :first_name => 'James',
      :last_name => 'Kirk',
      :user_name => 'tiberius',
      :gender => 'Male',
      :dob => '04/30/1950',
      :email => 'robert.schuman@gmail.com',
      :mobile_phone => '78978987998978123',
      :grad_month => 05,
      :grad_year => 2008,
      :highest_degree_level => 'Bachelor',
      :school_name => 'Starfleet Academy',
      :school_town_city => 'San Francisco',
      :school_state_province => 'CA',
      :school_country => 'USA',
      :gpa => 2.9,
      :gpa_scale => 4.0,
      :academic_other_info => 'I was commended for beating the Kobayashi Maru, the unwinnable scenario.',
      :home_street_1 => '13 Kirkland Blvd',
      :home_street_2 => '',
      :home_town_city => 'San Francisco',
      :home_state_province => 'CA',
      :home_country => 'USA',
      :home_postal_code => '12345',
      :home_phone => '7895462 45668 454213',
      :home_phone_country_code => 1,
      :dorm_street_1 => '',
      :dorm_street_2 => '',
      :dorm_town_city => '',
      :dorm_state_province => '',
      :dorm_postal_code => '',
      :dorm_country => '',
      :dorm_phone => '',
      :dorm_phone_country_code => ''
    )

    Applicant.create(
      :first_name => 'Jean-Luc',
      :last_name => 'Picard',
      :user_name => 'locutus',
      :gender => 'Male',
      :dob => '03/12/1945',
      :email => 'robert.schuman@gmail.com',
      :mobile_phone => '7898 465 45 615456',
      :grad_month => 01,
      :grad_year => 1960,
      :highest_degree_level => 'PhD',
      :school_name => 'Starfleet Academy',
      :school_town_city => 'San Francisco',
      :school_state_province => 'CA',
      :school_country => 'USA',
      :gpa => 3.7,
      :gpa_scale => 4.0,
      :academic_other_info => 'Member of the \'Much Ado About Nothing\' secret society.',
      :home_street_1 => '57 Laurient Ave',
      :home_street_2 => '',
      :home_town_city => 'Paris',
      :home_state_province => '',
      :home_country => 'France',
      :home_postal_code => 'W890 H90',
      :home_phone => '456 123378 989546',
      :home_phone_country_code => '64',
      :dorm_street_1 => '78 Orion Syndicate Lane',
      :dorm_street_2 => '',
      :dorm_town_city => 'San Jose',
      :dorm_state_province => 'CA',
      :dorm_postal_code => '45678',
      :dorm_country => 'USA',
      :dorm_phone => '4566132 02312 5654 23',
      :dorm_phone_country_code => 1
   )

   Applicant.create(
      :first_name => 'Edward',
      :last_name => 'Norton',
      :user_name => 'robertpaulson',
      :gender => 'Other/Prefer not to answer',
      :dob => '11/11/1971',
      :email => 'robert.schuman@gmail.com',
      :mobile_phone => '5465879321',
      :grad_month => 04,
      :grad_year => 1989,
      :highest_degree_level => 'High school',
      :school_name => 'Roger P. Murphy High School',
      :school_town_city => 'Chicago',
      :school_state_province => 'Illinois',
      :school_country => 'USA',
      :gpa => 2.4,
      :gpa_scale => 4.0,
      :academic_other_info => '',
      :home_street_1 => '87 Santa Monica Blvd',
      :home_street_2 => '',
      :home_town_city => 'Los Angeles',
      :home_state_province => 'CA',
      :home_country => 'USA',
      :home_postal_code => '90210',
      :home_phone => '123 87952412',
      :home_phone_country_code => 1, 
      :dorm_street_1 => '',
      :dorm_street_2 => '',
      :dorm_town_city => '',
      :dorm_state_province => '',
      :dorm_postal_code => '',
      :dorm_country => '',
      :dorm_phone => '',
      :dorm_phone_country_code => ''
   )

   Applicant.create(
      :first_name => 'Kathryn',
      :last_name => 'Janeway',
      :user_name => 'katiej',
      :gender => 'Female',
      :dob => '08/07/1965',
      :email => 'robert.schuman@gmail.com',
      :mobile_phone => '78945641213',
      :grad_month => 11,
      :grad_year => 1975,
      :highest_degree_level => 'Graduate',
      :school_name => 'University of New Hampshire',
      :school_town_city => 'Durham',
      :school_state_province => 'NH',
      :school_country => 'USA',
      :gpa => 3.9,
      :gpa_scale => 4.0,
      :academic_other_info => '',
      :dorm_street_1 => '7 Baghad Drive',
      :dorm_street_2 => '',
      :dorm_town_city => 'Durham',
      :dorm_state_province => 'NH',
      :dorm_postal_code => '03123',
      :dorm_country => 'USA',
      :dorm_phone => '44661231854',
      :dorm_phone_country_code => 1,
      :home_street_1 => '76 Lee St',
      :home_street_2 => '',
      :home_town_city => 'Manchester',
      :home_state_province => 'NH',
      :home_country => 'USA',
      :home_postal_code => '03109',
      :home_phone => '54651312123854',
      :home_phone_country_code => 1
   )

   JobApplicationReferral.create(
      :job_application_id => 1,
      :first_name => 'Barak',
      :last_name => 'Obama',
      :email => 'robert.schuman@gmail.com',
      :phone => '22135432120465',
      :title => 'President of the USA',
      :notes => '',
      :referral_text => 'He or She is a good kid.'
   )

   JobApplicationReferral.create(
      :job_application_id => 1,
      :first_name => 'Barbara',
      :last_name => 'Bush',
      :email => 'robert.schuman@gmail.com',
      :phone => '152465432132',
      :title => 'Wife of the better President Bush',
      :notes => '',
      :referral_text => 'Lovely person, just said \'no\' to drugs.'
   )
   
   JobApplication.create(
      :apptracker_id => 1,
      :applicant_id => 2,
      :job_id => 1,
      :submission_status => 'Unsubmitted',
      :acceptance_status => 'Pending'
   )
   
   JobApplication.create(
      :apptracker_id => 1,
      :applicant_id => 2,
      :job_id => 2,
      :submission_status => 'Submitted',
      :acceptance_status => 'Accepted'
   )

   JobApplication.create(
      :apptracker_id => 1,
      :applicant_id => 2,
      :job_id => 3,
      :submission_status => 'Submitted',
      :acceptance_status => 'Declined'
   )

   JobApplication.create(
      :apptracker_id => 1, 
      :applicant_id => 3,
      :job_id => 1,
      :submission_status => 'Submitted',
      :acceptance_status => 'Declined'
   )

   JobApplication.create(
      :apptracker_id => 2,
      :applicant_id => 3,
      :job_id => 2,
      :submission_status => 'Submitted',
      :acceptance_status => 'Accepted'
   )

  end

  def self.down
    # delete all previous records
    JobApplicationMaterial.delete_all
    JobApplicationReferral.delete_all
    JobApplicationCustomField.delete_all
    JobApplication.delete_all
    JobCustomField.delete_all
    JobAttachment.delete_all
    Job.delete_all
    Applicant.delete_all
    Apptracker.delete_all
  end
end
