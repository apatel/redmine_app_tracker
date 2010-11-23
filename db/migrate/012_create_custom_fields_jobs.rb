class CreateCustomFieldsJobs < ActiveRecord::Migration
  def self.up
    create_table :custom_fields_jobs, :id => false do |t|
      t.references :custom_field
      t.references :job
      t.timestamps
    end
  end

  def self.down
    drop_table :custom_fields_jobs
  end
end
