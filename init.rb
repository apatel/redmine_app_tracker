require 'redmine'
# TODO find out if all RESTful actions need a matching permission
Redmine::Plugin.register :redmine_apptracker do
  name 'Redmine Apptracker plugin'
  author 'Robert A. Schuman'
  description 'An application tracker plugin for Redmine.'
  version '0.0.1'

  # Set controller action access permissions
  # - any controller filter (such as before_filter) that sets permissions (such as :require_admin) 
  # will always override any permissions set in this file or in the redmine roles/permission GUI
  # 
  project_module :application_tracker do
    # apptracker privileges
    permission :view_apptrackers, :apptrackers => :index
    permission :create_an_apptracker, :apptrackers => :new
    permission :edit_an_apptracker, :apptrackers => :edit
    permission :destroy_an_apptracker, :apptrackers => :destroy
    
    # job privileges
    permission :view_jobs, :jobs => :index
    permission :create_a_job, :jobs => :new

    # referrer privileges
    permission :create_a_referrer, :referrers => :new
    permission :edit_a_referrer, :referrers => :edit
  end

  # set menu options; commented :if used for setting menu to visible if logged in
  menu(:project_menu, :apptrackers, {:controller => 'apptrackers', :action => 'index'}, :caption => "AppTracker", :after => :overview, :param => :project_identifier) #, :if => Proc.new{User.current.logged?})

  if RAILS_ENV == 'development'
    ActiveSupport::Dependencies.load_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
  end  
end
