class CreateJobApplications < ActiveRecord::Migration
  def self.up
    create_table :job_applications do |t|
      t.integer :apptracker_id
      t.integer :applicant_id
      t.integer :job_id
      t.string :submission_status
      t.string :acceptance_status
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :job_applications
  end
end
