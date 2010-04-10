module Typus

  module Reloader

    # Reload configuration always but in production.
    def reload_config_and_roles
      Typus::Configuration.reload! unless Rails.env.production?
    end

  end

end
