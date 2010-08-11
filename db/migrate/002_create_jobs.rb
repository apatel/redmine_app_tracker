class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.column :apptracker_id, :integer
      t.column :title, :string
      t.column :category, :string
      t.column :description, :string
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
