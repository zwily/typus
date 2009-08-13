if defined?(ActionController::Routing::RouteSet)

  class ActionController::Routing::RouteSet

    def load_routes_with_typus!
      lib_path = File.dirname(__FILE__)
      typus_routes = File.join(lib_path, *%w[ .. .. .. config typus_routes.rb ])
      add_configuration_file(typus_routes) unless configuration_files.include?(typus_routes)
      load_routes_without_typus!
    end

    alias_method_chain :load_routes!, :typus

  end

end