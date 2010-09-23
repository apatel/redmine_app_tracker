# TODO Implement this controller
class JobAttachmentsController < ApplicationController
  model_object JobAttachment
  default_search_scope :documents
  before_filter :find_project, :only => [:index, :new]
  before_filter :find_model_object, :except => [:index, :new]
  before_filter :find_project_from_association, :except => [:index, :new]

  helper :attachments

  def index
    
  end

  def show
  end

  def new

  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
