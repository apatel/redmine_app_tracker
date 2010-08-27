# Redmine's current syntax for linking to RESTful resources
ActionController::Routing::Routes.draw do |map| 
  map.resources :apptrackers
  # following connect needed for controller's "render :action => 'new'" method
  # map.connect 'apptrackers/:action.:format', :controller => 'apptrackers'
  #map.connect 'apptrackers/new', :controller => 'apptrackers', :action => 'new', :conditions => {:method => :post}
  map.resources :applicants
  map.resources :application_materials
  map.connect   'application_materials/download/:id', :controller => 'application_materials', :action => 'download'
  map.resources :jobs
  map.resources :referrers

  # default routes
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end

