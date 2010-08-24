RailsApp::Application.routes.draw do |map|

  map.connect "admin/delayed/tasks/:action/:id(.:format)", :controller => "admin/delayed/tasks"

  Typus::Routes.draw(map)
  root :to => "welcome#index"

end
