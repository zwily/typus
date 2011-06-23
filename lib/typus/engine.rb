module Admin
  class Engine < Rails::Engine

    paths["app/assets"] << "app/themes/default/assets"
    paths["app/views"] << "app/themes/default/views"

  end
end
