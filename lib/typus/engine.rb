module Admin
  class Engine < Rails::Engine

    paths["app/assets"] << "app/themes/default/assets"
    paths["app/views"] << "app/themes/default/views"

#    isolate_namespace Admin

  end
end
