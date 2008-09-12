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
    #
    @@options = { :app_name => 'Typus Admin',
                  :app_description => '',
                  :per_page => 15,
                  :version => '',
                  :form_rows => '10',
                  :form_columns => '10', 
                  :toggle => true, 
                  :edit_after_create => true }

    mattr_reader :options

    ##
    # Read Typus Configuration file
    #
    case ENV['RAILS_ENV']
    when 'test'
      config_file = "#{File.dirname(__FILE__)}/../../test/typus.yml"
      @@config = YAML.load_file(config_file)
    else
      @@config = {}
      Dir['vendor/plugins/*/config/typus.yml'].each do |plugin|
        @@config = @@config.merge(YAML.load_file("#{RAILS_ROOT}/#{plugin}"))
      end
      config_file = "#{RAILS_ROOT}/config/typus.yml"
      @@config = @@config.merge(YAML.load_file(config_file))
    end

    mattr_reader :config

    ##
    # Read Typus Roles
    #
    case ENV['RAILS_ENV']
    when 'test'
      config_file = "#{File.dirname(__FILE__)}/../../test/typus_roles.yml"
      @@roles = YAML.load_file(config_file)
    else
      @@roles = {}
      Dir['vendor/plugins/*/config/typus_roles.yml'].each do |role|
        @@roles = @@roles.merge(YAML.load_file("#{RAILS_ROOT}/#{role}"))
      end
      typus_roles_file = "#{RAILS_ROOT}/config/typus_roles.yml"
      if File.exists?(typus_roles_file)
        @@roles = @@roles.merge(YAML.load_file(typus_roles_file))
      end
    end

    mattr_reader :roles

  end

end