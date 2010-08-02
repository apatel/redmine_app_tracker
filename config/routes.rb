=begin
map.resource :apptrackers
map.connect 'projects/:project_id/apptrackers', :controller => 'apptrackers', :action => 'index'
map.connect 'projects/:project_id/apptrackers/new', :controller => 'apptrackers', :action => 'new'
map.connect 'projects/:project_id/apptrackers/edit', :controller => 'apptrackers', :action => 'edit'
map.connect 'projects/:project_id/apptrackers/create', :controller => 'apptrackers', :action => 'create'
=end


ActionController::Routing::Routes.draw do |map| 
#  map.destroy_apptracker '/apptrackers/:id', :controller => 'apptrackers', :action => 'destroy', :method => 'delete'
  map.resources :apptrackers
end


#_url _path
# named_routes
# map.apptrackers '/projects/:project_id/apptrackers', :controller => 'apptrackers', :action => 'index'
# map.apptrackers '/projects/:project_id/apptrackers/:apptracker_id', ....
# link_to apptrackers_url(@project.id)
# link_to apptrackers_url(@projects.id, @apptracker.id)

