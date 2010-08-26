class CreateApptrackers < ActiveRecord::Migration
  def self.up
    create_table :apptrackers do |t|
      t.integer :project_id
      t.string :title
      t.string :description
      t.boolean :apptracker_status
      
      t.timestamps
    end
  end

  def self.down
    drop_table :apptrackers
  end
end
