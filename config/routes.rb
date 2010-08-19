# Redmine's current syntax for linking to RESTful resources
ActionController::Routing::Routes.draw do |map| 
  map.resources :applicants
  map.resources :application_materials
  map.connect 'application_materials/download/:id', :controller => 'application_materials', :action => 'download'
  map.resources :apptrackers
  map.resources :jobs
end

# Previous syntax for creating routes to controller actions
=begin
map.resource :apptrackers
map.connect 'projects/:project_id/apptrackers', :controller => 'apptrackers', :action => 'index'
map.connect 'projects/:project_id/apptrackers/new', :controller => 'apptrackers', :action => 'new'
map.connect 'projects/:project_id/apptrackers/edit', :controller => 'apptrackers', :action => 'edit'
map.connect 'projects/:project_id/apptrackers/create', :controller => 'apptrackers', :action => 'create'
=end
