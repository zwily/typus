# coding: utf-8

module Typus

  # Define the application name.
  mattr_accessor :app_name
  @@app_name = "Typus"

  # Define the configuration folder.
  mattr_accessor :config_folder
  @@config_folder = "config/typus"

  # Define the default password.
  mattr_accessor :default_password
  @@default_password = "columbia"

  # Define the default email.
  mattr_accessor :email
  @@email = nil

  # Define the file preview.
  mattr_accessor :file_preview
  @@file_preview = :typus_preview

  # Define the file thumbnail.
  mattr_accessor :file_thumbnail
  @@file_thumbnail = :typus_thumbnail

  # Defines the default relationship table.
  mattr_accessor :relationship
  @@relationship = "typus_users"

  # Defines the default master role.
  mattr_accessor :master_role
  @@master_role = "admin"

  # Defines the default user_class_name.
  mattr_accessor :user_class_name
  @@user_class_name = "TypusUser"

  # Defines the default user_fk.
  mattr_accessor :user_fk
  @@user_fk = "typus_user_id"

  class << self

    # Default way to setup typus. Run rails generate typus to create
    # a fresh initializer with all configuration values.
    def setup
      yield self
    end

    def root
      (File.dirname(__FILE__) + "/../").chomp("/lib/../")
    end

    def locales
      { "ca" => "Català", 
        "de" => "German", 
        "en" => "English", 
        "es" => "Español", 
        "fr" => "Français", 
        "hu" => "Magyar", 
        "pt-BR" => "Portuguese", 
        "ru" => "Russian" }
    end

    def applications
      Configuration.config.collect { |i| i.last["application"] }.compact.uniq.sort
    end

    # List of the modules of an application.
    def application(name)
      Configuration.config.collect { |i| i.first if i.last["application"] == name }.compact.uniq.sort
    end

    # Gets a list of all the models from the configuration file.
    def models
      Configuration.config.map { |i| i.first }.sort
    end

    def models_on_header
      models.collect { |m| m if m.constantize.typus_options_for(:on_header) }.compact
    end

    # List of resources, which are tableless models.
    def resources
      Configuration.roles.keys.map do |key|
        Configuration.roles[key].keys
      end.flatten.sort.uniq.delete_if { |x| models.include?(x) }
    end

    # Gets a list of models under app/models
    def detect_application_models
      model_dir = Rails.root.join("app/models")
      Dir.chdir(model_dir) do
        models = Dir["**/*.rb"]
      end
    end

    def application_models
      detect_application_models.map do |model|
        class_name = model.sub(/\.rb$/,"").camelize
        klass = class_name.split("::").inject(Object) { |klass,part| klass.const_get(part) }
        class_name if klass < ActiveRecord::Base && !klass.abstract_class?
      end.compact
    end

    def user_class
      user_class_name.constantize
    end

    def reload!
      Configuration.roles!
      Configuration.config!
    end

    def boot!

      # Some Typus requirements ...
      require "typus/configuration"
      require "typus/routes"
      require "typus/authentication"
      require "typus/preferences"
      require "typus/reloader"
      require "typus/format"
      require "typus/templates"
      require "typus/resource"

      # Ruby/Rails Extensions
      require "extensions/hash"
      require "extensions/object"
      require "extensions/string"
      require "extensions/active_record"

      # Active Record Extensions.
      require "typus/active_record"

      # Typus mixins.
      require "typus/user"

      # Vendor.
      require "vendor/paginator"

    end

  end

end
