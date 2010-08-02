class Apptracker < ActiveRecord::Base
  # associations
  has_many :jobs, :dependent => :destroy
  
  # validation
  validates_presence_of :title, :message => 'Please enter a title'
  validates_uniqueness_of :title

  def self.find_all_apptrackers
    find(:all, :order => 'title')
  end

  def after_destroy
    if Apptracker.count.zero?
      raise 'No application tracker to delete.'
    end
  end
end
