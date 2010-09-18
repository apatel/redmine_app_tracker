class CreateJobApplicationMaterials < ActiveRecord::Migration
  def self.up
    create_table :job_application_materials do |t|
      t.integer :job_application_id
      t.string :material_type
      t.string :title
      t.string :notes
      t.string :filename

      t.timestamps
    end
  end

  def self.down
    drop_table :job_application_materials
  end
end
