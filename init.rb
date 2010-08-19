require 'redmine'
#TODO find out if all RESTful actions need a matching permission
Redmine::Plugin.register :redmine_apptracker do
  name 'Redmine Apptracker plugin'
  author 'Robert A. Schuman'
  description 'An application tracker plugin for Redmine.'
  version '0.0.1'

  # Set controller action access permissions
  # - All unnacounted for controller actions in the following list will result in a denial of access to
  #   those controller actions for any users of the redmine system without admin status.
  # - When a permission is declared in the following list, the admin will also need to check/uncheck each
  #   matching permission found in the administration section of the site under "roles and permissions"
  project_module :application_tracker do
    # apptracker privileges
    permission :view_apptrackers, :apptrackers => :index
    permission :create_an_apptracker, :apptrackers => :new
    permission :edit_an_apptracker, :apptrackers => :edit
    permission :destroy_an_apptracker, :apptrackers => :destroy
    
    # job privileges
    permission :view_jobs, :jobs => :index
    permission :create_a_job, :jobs => :new
  end

  # set menu options; :if used for setting menu to visible if logged in
  menu(:project_menu, :apptrackers, {:controller => 'apptrackers', :action => 'index'}, :caption => "AppTracker", :after => :overview, :param => :project_id) #, :if => Proc.new{User.current.logged?})

  if RAILS_ENV == 'development'
    ActiveSupport::Dependencies.load_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
  end  
end
