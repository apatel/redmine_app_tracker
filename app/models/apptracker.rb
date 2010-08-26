class Apptracker < ActiveRecord::Base
  # associations
  has_many :jobs, :dependent => :destroy
  has_many :applicants, :dependent => :destroy
  has_many :application_materials, :through => :applicants
  
  # validation
  validates_presence_of :title, :message => 'Please enter a title'
  validates_uniqueness_of :title

  # constants
  APPTRACKER_PLUGIN_FOLDER = "redmine_apptracker"

  def self.find_all_apptrackers
    find(:all, :order => 'title')
  end

  def after_destroy
    if Apptracker.count.zero?
      raise 'No application tracker to delete.'
    end
  end
end
