class CreateJobApplicationCustomFields < ActiveRecord::Migration
  def self.up
    create_table :job_application_custom_fields, :id => false do |t|
      t.references :custom_field
      t.references :job_application
      t.timestamps
    end
  end

  def self.down
    drop_table :job_application_custom_fields
  end
end