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
    #   Typus::Configuration.options[:password_recover] = false
    #
    @@options = { :app_name => 'Typus Admin',
                  :app_description => '',
                  :per_page => 15,
                  :version => '',
                  :form_rows => '10',
                  :form_columns => '10', 
                  :toggle => true, 
                  :edit_after_create => true, 
                  :root => 'admin', 
                  :password_recover => true }

    mattr_reader :options

    ##
    # Read Typus Configuration file
    #

    folders = Dir['vendor/plugins/*/config/typus.yml']
    folders << "vendor/plugins/typus/test/config/typus.yml" if ENV['RAILS_ENV'] == 'test'

    @@config = {}
    folders.each do |plugin|
      @@config = @@config.merge(YAML.load_file("#{RAILS_ROOT}/#{plugin}"))
    end

    config_file = "#{RAILS_ROOT}/config/typus.yml"
    if File.exists?(config_file) && !File.zero?(config_file)
      @@config = @@config.merge(YAML.load_file(config_file))
    end

    mattr_reader :config

    ##
    # Read Typus Roles
    #

    folders = Dir['vendor/plugins/*/config/typus_roles.yml']
    folders << "vendor/plugins/typus/test/config/typus_roles.yml" if ENV['RAILS_ENV'] == 'test'

    @@roles = { 'admin' => {} }
    folders.each do |role|
      YAML.load_file("#{RAILS_ROOT}/#{role}").each do |key, value|
        @@roles['admin'] = @@roles['admin'].merge(value)
      end
    end

    config_file = "#{RAILS_ROOT}/config/typus_roles.yml"
    if File.exists?(config_file) && !File.zero?(config_file)
      app_roles = YAML.load_file(config_file)
      @@roles['admin'] = @@roles['admin'].merge(app_roles['admin'])
    end

    mattr_reader :roles

  end

end