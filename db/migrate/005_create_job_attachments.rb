class CreateJobAttachments < ActiveRecord::Migration
  def self.up
    create_table :job_attachments do |t|
      t.integer :job_id
      t.string :filename
      t.string :name
      t.string :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :job_attachments
  end
end
