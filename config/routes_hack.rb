ActionController::Routing::Routes.draw do |map|

  begin
    ActionController::Routing::Routes.recognize_path '/admin/typus_users'
  rescue
    map.connect ':controller/:action/:id'
  end

end