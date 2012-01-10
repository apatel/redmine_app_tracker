class AddJobsShortDescription < ActiveRecord::Migration
  def self.up
    add_column :jobs, :short_desc, :text
  end

  def self.down
    remove_column :jobs, :short_desc
  end
end