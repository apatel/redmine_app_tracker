class Apptracker < ActiveRecord::Base
  # associations
  has_many :jobs, :dependent => :destroy
  has_and_belongs_to_many :applicants
  belongs_to :project

  # validation
  validates_presence_of :title, :status
  validates_uniqueness_of :title

  # constants
  # TODO convert these values into variables that can be set from a settings page within Redmine
  APPTRACKER_PLUGIN_FOLDER = "redmine_apptracker"
  STATUS_OPTIONS = ['Active','Inactive']

  def self.find_all_apptrackers
    find(:all, :order => 'title')
  end

  def after_destroy
    if Apptracker.count.zero?
      raise 'No application tracker to delete.'
    end
  end

end
