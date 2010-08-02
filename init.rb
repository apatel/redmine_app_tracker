require 'redmine'

Redmine::Plugin.register :redmine_apptracker do
  name 'Redmine Apptracker plugin'
  author 'Robert A. Schuman'
  description 'An application tracker plugin for Redmine.'
  version '0.0.1'

  # set permissions
  
  # necessary for displaying a project menu tab
  # permission :apptracker, {:apptrackers => [:index]}, :public => true 
  # permission :create_jobs, :jobs => :create
  project_module :application_tracker do
    permission :view_application_trackers, :apptrackers => :index
    permission :create_an_apptracker, :apptrackers => :create
    permission :new_apptracker, :apptrackers => :new
  end

  # set menu options; :if used for setting menu to visible if logged in
  menu(:project_menu, :apptrackers, {:controller => 'apptrackers', :action => 'index'}, :caption => "AppTracker", :after => :overview) #, :param => :project_id) #, :if => Proc.new{User.current.logged?})

  if RAILS_ENV == 'development'
    ActiveSupport::Dependencies.load_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
  end  
end
