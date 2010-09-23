class CreateApplicants < ActiveRecord::Migration
  # TODO look to see if some fields are better set as integer types (phone number, area codes, etc.)
  def self.up
    create_table :applicants do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_name
      t.string :gender
      t.string :applicant_type
      t.date :dob
      t.string :email
      t.string :mobile_phone
      t.integer :grad_month 
      t.integer :grad_year
      t.string :highest_degree_level
      t.string :school_name
      t.string :school_town_city
      t.string :school_state_province
      t.string :school_country
      t.float  :gpa
      t.float  :gpa_scale
      t.string :academic_other_info
      t.string :dorm_street_1
      t.string :dorm_street_2
      t.string :dorm_town_city
      t.string :dorm_state_province
      t.string :dorm_postal_code
      t.string :dorm_country
      t.string :dorm_phone
      t.string :dorm_phone_country_code
      t.string :home_street_1
      t.string :home_street_2
      t.string :home_town_city
      t.string :home_state_province
      t.string :home_country
      t.string :home_postal_code
      t.string :home_phone
      t.string :home_phone_country_code

      t.timestamps
    end
  end

  def self.down
    drop_table :applicants
  end
end
