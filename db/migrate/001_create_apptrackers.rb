class CreateApptrackers < ActiveRecord::Migration
  def self.up
    create_table :apptrackers do |t|
      t.column :title, :string
      t.column :description, :string
    end
  end

  def self.down
    drop_table :apptrackers
  end
end
