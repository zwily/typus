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
    #   Typus::Configuration.options[:email] = 'admin@example.com'
    #   Typus::Configuration.options[:password] = 8
    #   Typus::Configuration.options[:special_characters_on_password] = true
    #   Typus::Configuration.options[:ssl] = false
    #
    @@options = { :app_name => 'Typus', 
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
                  :disable_typus_enabled_plugins => false, 
                  :email => 'admin@example.com', 
                  :password => 8, 
                  :special_characters_on_password => false, 
                  :ssl => false }

    mattr_accessor :options

    ##
    # This switch allows us to disable Typus plugins, used only for
    # demo purposes.
    #
    @@switch = @@options[:disable_typus_enabled_plugins] ? 'typus' : '*'

    ##
    # Read Typus Configuration file
    #
    #   Typus::Configuration.config! overwrites @@config
    #
    def self.config!

      folders = Dir["vendor/plugins/#{@@switch}/config/typus.yml"]
      folders = ["vendor/plugins/typus/test/config/typus.yml"] if ENV['RAILS_ENV'] == 'test'

      @@config = {}
      folders.each do |folder|
        @@config = @@config.merge(YAML.load_file("#{RAILS_ROOT}/#{folder}"))
      end

      config_file = "#{RAILS_ROOT}/config/typus.yml"
      if File.exists?(config_file) && !File.zero?(config_file) && !Rails.test?
        @@config = @@config.merge(YAML.load_file(config_file))
      end

      return @@config

    end

    mattr_accessor :config

    ##
    # Read Typus Roles
    #
    #   Typus::Configuration.roles! overwrites @@roles
    #
    def self.roles!

      folders = Dir["vendor/plugins/#{@@switch}/config/typus_roles.yml"]
      folders = ["vendor/plugins/typus/test/config/typus_roles.yml"] if ENV['RAILS_ENV'] == 'test'

      @@roles = { 'admin' => {} }
      folders.each do |folder|
        YAML.load_file("#{RAILS_ROOT}/#{folder}").each do |key, value|
          @@roles['admin'] = @@roles['admin'].merge(value)
        end
      end

      if ENV['RAILS_ENV'] == 'test'
        config_file = "#{RAILS_ROOT}/vendor/plugins/typus/test/config/typus_roles.yml"
      else
        config_file = "#{RAILS_ROOT}/config/typus_roles.yml"
      end

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

      return @@roles

    end

    mattr_accessor :roles

  end

end