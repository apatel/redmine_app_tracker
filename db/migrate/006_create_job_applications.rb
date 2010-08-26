class CreateJobApplications < ActiveRecord::Migration
  def self.up
    create_table :job_applications do |t|
      t.integer :apptracker_id
      t.integer :applicant_id
      t.integer :job_id
      t.string :job_application_status

      t.timestamps
    end
  end

  def self.down
    drop_table :job_applications
  end
end
