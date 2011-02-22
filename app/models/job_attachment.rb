class JobAttachment < ActiveRecord::Base
  unloadable

  # associations
  belongs_to :job
  # TODO Does a delete permission need to be added to the acts_as_attachable association?
  acts_as_attachable

  # validations
  validates_presence_of :filename, :name

  # TODO Should I implement internal file renaming for identical filenames uploaded by different applicants?
  validates_uniqueness_of :filename

  # constants
  
  def attachments_deletable?(usr=User.current)
    if User.current.admin?
      true
    else
      false
    end  
  end
  
  def project
    self.job.apptracker.project
  end
  
  def visible?(user=User.current)
    #!user.nil? && user.allowed_to?(:view_documents, project)
    true
  end
  
  def attachments_visible?(user=User.current)
    #user.allowed_to?(self.class.attachable_options[:view_permission], self.project)
    true
  end
 
end
