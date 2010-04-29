module Typus

  module Configuration

    # Read Typus Configuration files placed on <tt>config/typus/**/*.yml</tt>.
    def self.config!
      application = Dir[Rails.root.join(Typus.config_folder, "**", "*.yml")]
      plugins = Dir[Rails.root.join("vendor", "plugins", "*", "config", "typus", "*.yml")]
      files = (application + plugins).reject { |f| f.include?("_roles.yml") }

      @@config = {}
      files.each do |file|
        if data = YAML::load_file(file)
          @@config.merge!(data)
        end
      end

      return @@config
    end

    mattr_accessor :config

    # Read Typus Roles from configuration files placed on <tt>config/typus/**/*_roles.yml</tt>.
    def self.roles!
      application = Dir[Rails.root.join(Typus.config_folder, "**", "*_roles.yml")]
      plugins = Dir[Rails.root.join("vendor", "plugins", "*", "config", "typus", "*_roles.yml")]
      files = (application + plugins).sort

      @@roles = { Typus.master_role => {} }

      files.each do |file|
        data = YAML::load_file(file)
        next unless data
        data.each do |key, value|
          next unless value
          begin
            @@roles[key].merge!(value)
          rescue
            @@roles[key] = value
          end
        end
      end

      return @@roles.compact
    end

    mattr_accessor :roles

  end

end