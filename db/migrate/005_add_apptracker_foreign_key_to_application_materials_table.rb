class AddApptrackerForeignKeyToApplicationMaterialsTable < ActiveRecord::Migration
  def self.up
    add_column :application_materials, :apptracker_id, :integer
  end

  def self.down
    remove_column :application_materials, :apptracker_id
  end
end
