module Typus

  module Configuration

    module Reloader

      def reload_config_et_roles
        logger.info "[typus] Configuration files have been reloaded."
        Typus::Configuration.roles!
        Typus::Configuration.config!
      end

    end

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
    # Experimental options: (don't use in production)
    #
    #   Typus::Configuration.options[:actions_on_table] = false
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
                  :email => 'admin@example.com', 
                  :password => 8, 
                  :special_characters_on_password => false, 
                  :ssl => false, 
                  :actions_on_table => false }

    mattr_accessor :options

    ##
    # Read Typus Configuration file
    #
    #   Typus::Configuration.config! overwrites @@config
    #
    def self.config!

      folders = if Rails.test?
                  ["vendor/plugins/typus/test/config/typus.yml"]
                else
                  Dir["config/typus/*"] - Dir["config/typus/*"].grep(/roles.yml/)
                end

      @@config = {}
      folders.each do |folder|
        @@config = @@config.merge(YAML.load_file("#{RAILS_ROOT}/#{folder}"))
      end

      config_file = if Rails.test?
                      "#{RAILS_ROOT}/vendor/plugins/typus/test/config/typus.yml"
                    else
                      "#{RAILS_ROOT}/config/typus.yml"
                    end

      if File.exists?(config_file) && !File.zero?(config_file) && !Rails.test?
        data = YAML.load_file(config_file)
        @@config = @@config.merge(data) if data
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

      folders = if Rails.test?
                  ["vendor/plugins/typus/test/config/typus_roles.yml"]
                else
                  Dir["config/typus/*_roles.yml"]
                end

      @@roles = { 'admin' => {} }

      folders.each do |folder|
        YAML.load_file("#{RAILS_ROOT}/#{folder}").each do |key, value|
          begin
            @@roles[key] = @@roles[key].merge(value)
          rescue
            @@roles[key] = value
          end
        end
      end

      config_file = if Rails.test?
                      "#{RAILS_ROOT}/vendor/plugins/typus/test/config/typus_roles.yml"
                    else
                      "#{RAILS_ROOT}/config/typus_roles.yml"
                    end

      if File.exists?(config_file) && !File.zero?(config_file)
        app_roles = YAML.load_file(config_file)
        app_roles.each do |key, value|
          case key
          when 'admin'
            begin
              @@roles[key] = @@roles[key].merge(app_roles[key])
            rescue
            end
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