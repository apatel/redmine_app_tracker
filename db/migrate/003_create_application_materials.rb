class CreateApplicationMaterials < ActiveRecord::Migration
  def self.up
    create_table :application_materials do |t|
      t.integer :applicant_id
      t.string :material_type
      t.string :title
      t.string :filename
      
      t.timestamps
    end
  end

  def self.down
    drop_table :application_materials
  end
end
