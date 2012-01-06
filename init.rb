require 'redmine'
# TODO find out if all RESTful actions need a matching permission

# Patches to the Redmine core
require 'dispatcher'

Dispatcher.to_prepare :redmine_apptracker do
  require_dependency 'custom_fields_helper'
  CustomFieldsHelper.send(:include, CustomFieldsHelperPatch) unless CustomFieldsHelper.included_modules.include?(CustomFieldsHelperPatch)
  
  #overriding the 30 character limit on the name attribute for custom fields
  CustomField.class_eval{
    def validate
      super
      remove_name_too_long_error!(errors)
    end

    def remove_name_too_long_error!(errors)
      errors.each_error do |attribute, error|
        if error.attribute == :name && error.type == :too_long
          errors_hash = errors.instance_variable_get(:@errors)
          if Array == errors_hash[attribute] && errors_hash[attribute].size > 1
            errors_hash[attribute].delete_at(errors_hash[attribute].index(error))
          else
            errors_hash.delete(attribute)
          end
        end
      end
    end
  }
  
end

Redmine::Plugin.register :redmine_apptracker do
  name 'Redmine Apptracker plugin'
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
    permission :manage_job_attachments, :job_attachments => [:create, :update, :destroy]

    # referrer privileges
    permission :create_a_referrer, :referrers => :new
    permission :edit_a_referrer, :referrers => :edit
  end

  # set menu options; commented :if used for setting menu to visible if logged in
  menu(:project_menu, :apptrackers, {:controller => 'apptrackers', :action => 'index'}, :caption => "Application Tracker", :after => :overview, :param => :project_identifier) #, :if => Proc.new{User.current.logged?})
  #menu :application_menu, :apptrackers, { :controller => 'apptrackers', :action => 'index' }, :caption => 'AppTracker'
  
  if RAILS_ENV == 'development'
    ActiveSupport::Dependencies.load_once_paths.reject!{|x| x =~ /^#{Regexp.escape(File.dirname(__FILE__))}/}
  end  
  
  Redmine::Search.map do |search|
    search.register :applicants
    search.register :jobs
    search.register :apptrackers
  end

end
