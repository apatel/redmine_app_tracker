require_dependency 'custom_fields_helper'

module CustomFieldsHelperPatch
  def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :custom_fields_tabs, :job_application_tab
      end
    end

    module InstanceMethods
      # Adds a job application tab to the user administration page
      def custom_fields_tabs_with_job_application_tab
        tabs = custom_fields_tabs_without_job_application_tab
        tabs << {:name => 'JobApplicationCustomField', :partial => 'custom_fields/index', :label => 'Job Applications'}
        return tabs
      end
    end
end