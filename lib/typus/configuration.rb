module Typus

  module Configuration

    # Default application options that can be overwritten from
    # an initializer.
    #
    # Example:
    #
    #   Typus::Configuration.options[:app_name] = "Your App Name"
    #   Typus::Configuration.options[:per_page] = 15
    #
    @@options = {
        :app_logo => '',
        :app_logo_height => '',
        :app_logo_width => '',
        :app_name => 'Typus Admin',
        :app_description => '',
        :per_page => 15,
        :prefix => 'admin',
        :color => '#000',
        :version => '',
        :signature => '',
        :form_rows => '10',
        :form_columns => '10' 
        }
    mattr_reader :options

    ##
    # Read Typus Configuration file
    case ENV['RAILS_ENV']
    when 'test'
      config_file = "#{File.dirname(__FILE__)}/../../test/typus.yml"
    else
      config_file = "#{RAILS_ROOT}/config/typus.yml"
    end

    @@config = YAML.load_file(config_file)

    mattr_reader :config

  end

end