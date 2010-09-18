class CreateJobApplicationReferrals < ActiveRecord::Migration
  def self.up
    create_table :job_application_referrals do |t|
      t.integer :job_application_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :title
      t.string :notes
      t.string :referral_text

      t.timestamps
    end
  end

  def self.down
    drop_table :job_application_referrals
  end
end
