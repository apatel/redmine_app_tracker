class CreateCustomFieldsJobApplications < ActiveRecord::Migration
  def self.up
    create_table :custom_fields_job_applications, :id => false do |t|
      t.references :custom_field
      t.references :job_application
      t.timestamps
    end
  end

  def self.down
    drop_table :custom_fields_job_applications
  end
end
