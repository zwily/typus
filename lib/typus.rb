module Typus

  class << self

    def applications
      apps = []
      Typus::Configuration.config.to_a.each do |model|
        if model[1].has_key? 'application'
          apps << model[1]['application']
        end
      end
      return apps.uniq.sort
    end

    def modules(app_name)
      submodules = []
      Typus::Configuration.config.to_a.each do |model|
        if model[1]['application'] == app_name
          submodules << model[0]
        end
      end
      return submodules.sort
    end

    def submodules(module_name)
      submodules = []
      Typus::Configuration.config.to_a.each do |model|
        if model[1]['module'] == module_name
          submodules << model[0]
        end
      end
      return submodules.sort
    end

    def parent_module(submodule_name)
      Typus::Configuration.config[submodule_name]['module']
    end

    def parent_application(module_name)
      Typus::Configuration.config[module_name]['application']
    end

    def models
      m = []
      Typus::Configuration.config.to_a.each do |model|
        m << model[0]
      end
      return m.sort
    end

    def enable
      enable_testing_models if RAILS_ENV == 'test'
      # enable_configuration
      enable_orm
      enable_routes
      enable_string
      enable_hash
      enable_authentication
      enable_patches if Rails.vendor_rails?
      enable_object
      enable_pagination
    end

    def enable_testing_models
      require File.dirname(__FILE__) + "/../test/test_models"
    end

    # def enable_configuration
    #   require 'typus/configuration'
    # end

    def enable_orm
      require 'typus/active_record'
    end

    def enable_routes
      require 'typus/routes'
    end

    def enable_string
      require 'typus/string'
    end

    def enable_hash
      require 'typus/hash'
    end

    def enable_authentication
      require 'typus/authentication'
    end

    def enable_patches
      require 'typus/patches'
    end

    def enable_object
      require 'typus/object'
    end

    def enable_pagination
      require 'vendor/paginator'
    end

    def generate_controllers

      ##
      # Cread admin folder for controllers if needed.
      #
      admin_controllers = "#{RAILS_ROOT}/app/controllers/admin"
      Dir.mkdir(admin_controllers) unless File.directory?(admin_controllers)

      ##
      # Get a list of all the available controllers
      #
      files = Dir['vendor/plugins/*/app/controllers/admin/*.rb']
      files += Dir['app/controllers/admin/*.rb']
      files = files.map { |i| i.split("/").last }

      ##
      # Generate needed controllers
      #
      self.models.each do |model|
        controller_filename = "#{model.tableize}_controller.rb"
        controller_location = "#{admin_controllers}/#{controller_filename}"
        if !files.include?(controller_filename)
          controller = File.open(controller_location, "w+")
          controller.puts "class Admin::#{model.pluralize}Controller < AdminController"
          controller.puts "end"
          controller.close
          puts "=> Admin::#{model.pluralize}Controller successfully created."
        end
      end
    end

  end

end