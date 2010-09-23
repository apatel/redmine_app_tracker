# Redmine's current syntax for linking to RESTful resources
ActionController::Routing::Routes.draw do |map|
  # FIXME Add routes for catching bad links when 1) a link is misspelled, and 2) when a page cannot be built due to a lack of needed params[]
  map.resources :apptrackers
  # following connect needed for controller's "render :action => 'new'" method
  # map.connect 'apptrackers/:action.:format', :controller => 'apptrackers'
  #map.connect 'apptrackers/new', :controller => 'apptrackers', :action => 'new', :conditions => {:method => :post}
  map.resources :applicants
  # TODO phase out the application materials model
  # map.resources :application_materials
  # map.connect   'application_materials/download/:id', :controller => 'application_materials', :action => 'download'
  map.resources :jobs
  # TODO phase out the referrer model
  # map.resources :referrers
  map.resources :job_applications
  map.resources :job_attachments
  map.resources :job_custom_fields
  map.resources :job_application_referrals
  map.resources :job_application_custom_fields
  map.resources :job_application_materials

  # default routes
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end

