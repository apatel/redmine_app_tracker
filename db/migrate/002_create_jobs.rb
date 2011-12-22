class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :apptracker_id
      t.string :category 
      t.string :title 
      t.text :description 
      t.integer :positions_available
      t.string :application_followup_message
      t.integer :application_material_count
      t.string :application_material_types
      t.integer :attachment_count
      t.string :attachment_ids
      t.string :referrer_count
      t.string :status
      t.datetime :submission_date

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
