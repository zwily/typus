module Typus

  module Configuration

    # Read Typus Configuration files placed on <tt>config/typus/**/*.yml</tt>.
    def self.config!

      files = Dir[File.join(Typus.config_folder, "**", "*.yml")].reject { |f| f.include?("_roles.yml") }

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

      files = Dir[File.join(Typus.config_folder, "**", "*_roles.yml")].sort

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