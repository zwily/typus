RailsApp::Application.routes.draw do |map|

  Typus::Routes.draw(map)
  root :to => "welcome#index"

end
