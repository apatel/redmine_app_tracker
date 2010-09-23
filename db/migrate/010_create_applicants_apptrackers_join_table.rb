class CreateApplicantsApptrackersJoinTable < ActiveRecord::Migration
  def self.up
    create_table :applicants_apptrackers, :id => false do |t|
      t.integer :applicant_id
      t.integer :apptracker_id
    end
  end

  def self.down
    drop_table :applicants_apptrackers
  end
end
