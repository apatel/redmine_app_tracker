class EditCustomFieldsName < ActiveRecord::Migration
  def self.up
    remove_column :custom_fields, :name
    add_column :custom_fields, :name, :text, :default => "", :null => false
  end

  def self.down
    remove_column :custom_fields, :name
    add_column  :custom_fields, :name, :limit => 30, :default => "", :null => false
  end
end
