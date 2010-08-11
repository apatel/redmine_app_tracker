class CreateApplicationMaterials < ActiveRecord::Migration
  def self.up
    create_table :application_materials do |t|
      t.column :applicant_id, :integer
      t.column :category, :string
      t.column :filename, :string
      t.column :title, :string
      t.column :description, :string
    end
  end

  def self.down
    drop_table :application_materials
  end
end
