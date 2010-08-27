class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :apptracker_id
      t.string :category 
      t.string :title 
      t.string :description 
      t.string :application_followup_message
      t.string :status
      t.string :custom_fields
      t.integer :attachment_count
      t.string :attachment_filenames
      t.string :referrer_count

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
