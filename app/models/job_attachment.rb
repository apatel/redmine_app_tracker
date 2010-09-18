class JobAttachment < ActiveRecord::Base
  unloadable

   # associations
  belongs_to :job

  # validations
  validates_presence_of :filename, :name

  # TODO Should I implement internal file renaming for identical filenames uploaded by different applicants?
  validates_uniqueness_of :filename

  # constants
 
end
