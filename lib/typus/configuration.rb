module Typus
  module Configuration

    # Read configuration from <tt>config/typus/*.yml</tt>.
    def self.config!
      files = Dir[Typus.config_folder.join("*.yml").to_s].reject { |f| f.match(/_roles.yml/) }

      files.each do |file|
        if data = YAML::load_file(file)
          @@config.merge!(data)
        end
      end
    end

    mattr_accessor :config
    @@config = {}

    def self.register_config(config)
      @@config.merge!(config)
    end

    # Read roles from files <tt>config/typus/*_roles.yml</tt>.
    def self.roles!
      files = Dir[Typus.config_folder.join("*_roles.yml").to_s].sort

      files.each do |file|
        if data = YAML::load_file(file)
          data.compact.each do |key, value|
            @@roles[key] ? @@roles[key].merge!(value) : (@@roles[key] = value)
          end
        end
      end
    end

    mattr_accessor :roles
    @@roles = {}

    def self.register_roles(roles)
      @@roles.merge!(roles)
    end

    def self.models_constantized!
      @@models_constantized = config.map { |i| i.first }.inject({}) { |result, model| result[model] = model.constantize; result }
    end

    mattr_accessor :models_constantized

  end
end