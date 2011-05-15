module Typus

  class Engine < Rails::Engine
    initializer "static assets" do |app|
      if app.config.serve_static_assets
        app.middleware.insert_after ::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/app/assets"
      end
    end
  end

end
