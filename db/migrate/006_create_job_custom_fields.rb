class CreateJobCustomFields < ActiveRecord::Migration
  def self.up
    create_table :job_custom_fields do |t|
      t.integer :job_id
      t.string :name
      t.string :field_type
      t.string :field_value
      t.string :validation_text

      t.timestamps
    end
  end

  def self.down
    drop_table :job_custom_fields
  end
end