class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.column :job_title, :string
      t.column :job_category, :string
      t.column :job_description, :string
      t.column :start_date, :date
      t.column :end_date, :date
      t.column :salary_range_low, :integer
      t.column :salary_range_high, :integer
      t.column :other_information, :string
      t.column :application_followup_message, :string
    end
  end

  def self.down
    drop_table :jobs
  end
end
