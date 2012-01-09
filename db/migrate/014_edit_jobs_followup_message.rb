class EditJobsFollowupMessage < ActiveRecord::Migration
  def self.up
    remove_column :jobs, :application_followup_message
    add_column :jobs, :application_followup_message, :text, :default => "", :null => false
  end

  def self.down
    remove_column :jobs, :application_followup_message
    add_column  :jobs, :application_followup_message, :string
  end
end