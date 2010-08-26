class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :apptracker_id
      t.string :category 
      t.string :title 
      t.string :description 
      t.string :application_followup_message
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
