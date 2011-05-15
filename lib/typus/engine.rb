module Typus

  class Engine < Rails::Engine
    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/app/assets"
    end
  end

end
