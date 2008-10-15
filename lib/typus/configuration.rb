module Typus

  module Configuration

    ##
    # Default application options that can be overwritten from
    # an initializer.
    #
    # Example:
    #
    #   Typus::Configuration.options[:app_name] = "Your App Name"
    #   Typus::Configuration.options[:app_description] = "Your App Description"
    #   Typus::Configuration.options[:per_page] = 15
    #   Typus::Configuration.options[:toggle] = true
    #   Typus::Configuration.options[:root] = 'admin'
    #   Typus::Configuration.options[:recover_password] = false
    #   Typus::Configuration.options[:disable_typus_enabled_plugins] = true
    #
    @@options = { :app_name => 'Typus Admin', 
                  :app_description => '', 
                  :per_page => 15, 
                  :version => '', 
                  :form_rows => 10, 
                  :form_columns => 10, 
                  :minute_step => 5, 
                  :toggle => true, 
                  :edit_after_create => true, 
                  :root => 'admin', 
                  :recover_password => true, 
                  :disable_typus_enabled_plugins => false }

    mattr_reader :options

    ##
    # Read Typus Configuration file
    #

    switch = @@options[:disable_typus_enabled_plugins] ? 'typus' : '*'

    folders = Dir["vendor/plugins/#{switch}/config/typus.yml"]
    folders << "vendor/plugins/typus/test/config/typus.yml" if ENV['RAILS_ENV'] == 'test'

    @@config = {}
    folders.each do |folder|
      @@config = @@config.merge(YAML.load_file("#{RAILS_ROOT}/#{folder}"))
    end

    config_file = "#{RAILS_ROOT}/config/typus.yml"
    if File.exists?(config_file) && !File.zero?(config_file)
      @@config = @@config.merge(YAML.load_file(config_file))
    end

    mattr_reader :config

    ##
    # Read Typus Roles
    #

    folders = Dir["vendor/plugins/#{switch}/config/typus_roles.yml"]
    folders << "vendor/plugins/typus/test/config/typus_roles.yml" if ENV['RAILS_ENV'] == 'test'

    @@roles = { 'admin' => {} }
    folders.each do |folder|
      YAML.load_file("#{RAILS_ROOT}/#{folder}").each do |key, value|
        @@roles['admin'] = @@roles['admin'].merge(value)
      end
    end

    config_file = "#{RAILS_ROOT}/config/typus_roles.yml"
    if File.exists?(config_file) && !File.zero?(config_file)
      app_roles = YAML.load_file(config_file)
      app_roles.each do |key, value|
        case key
        when 'admin'
          @@roles[key] = @@roles[key].merge(app_roles[key])
        else
          @@roles[key] = value
        end
      end
    end

    mattr_reader :roles

  end

end