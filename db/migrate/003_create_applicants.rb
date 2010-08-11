class CreateApplicants < ActiveRecord::Migration
  def self.up
    create_table :applicants do |t|
      t.column :apptracker_id, :integer
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :user_name, :string
      t.column :email, :string
      t.column :gender, :string
      t.column :applicant_type, :string
      t.column :dob, :date
      t.column :grad_month, :integer
      t.column :grad_year, :integer
      t.column :highest_degree_level, :string
      t.column :school_name, :string
      t.column :school_town_city, :string
      t.column :school_state_province, :string
      t.column :school_country, :string
      t.column :dorm_street1, :string
      t.column :dorm_street2, :string
      t.column :dorm_town_city, :string
      t.column :dorm_state_province, :string
      t.column :dorm_postal_code, :integer
      t.column :dorm_country, :string
      t.column :dorm_phone, :integer
      t.column :home_street1, :string
      t.column :home_street2, :string
      t.column :home_town_city, :string
      t.column :home_state_province, :string
      t.column :home_country, :string
      t.column :home_postal_code, :integer
      t.column :home_phone, :integer
      t.column :mobile_phone, :integer
    end
  end

  def self.down
    drop_table :applicants
  end
end
