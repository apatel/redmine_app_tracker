# Redmine's current syntax for linking to RESTful resources
ActionController::Routing::Routes.draw do |map|
  map.resources :apptrackers
  # following connect needed for controller's "render :action => 'new'" method
  # map.connect 'apptrackers/:action.:format', :controller => 'apptrackers'
  #map.connect 'apptrackers/new', :controller => 'apptrackers', :action => 'new', :conditions => {:method => :post}
  map.resources :applicants
  map.resources :jobs, :collection => {:zip_some => [:get,:post], :zip_all => [:get,:post]}
  map.resources :job_applications
  map.resources :job_attachments
  map.resources :job_custom_fields
  map.resources :job_application_referrals, :collection => {:request_referral => [:get,:post]}
  map.resources :job_application_materials, :collection => {:zip_files => [:get,:post]}

  # default routes
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end

