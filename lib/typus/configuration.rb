module Typus
  module Configuration

    # Read configuration from <tt>config/typus/*.yml</tt>.
    def self.models!
      @@config = {}

      Typus.model_configuration_files.each do |file|
        if data = YAML::load_file(file)
          @@config.merge!(data)
        end
      end
    end

    mattr_accessor :config
    @@config = {}

    # Read roles from files <tt>config/typus/*_roles.yml</tt>.
    def self.roles!
      @@roles = {}

      Typus.role_configuration_files.each do |file|
        if data = YAML::load_file(file)
          data.compact.each do |key, value|
            @@roles[key] ? @@roles[key].merge!(value) : (@@roles[key] = value)
          end
        end
      end
    end

    mattr_accessor :roles
    @@roles = {}

  end
end