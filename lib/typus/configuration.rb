module Typus
  module Configuration

    # Read configuration from <tt>config/typus/*.yml</tt>.
    def self.config!
      files = Dir[File.join(Typus.config_folder, "*.yml").to_s].reject { |f| f.match(/_roles.yml/) }

      @@config = {}

      files.each do |file|
        if data = YAML::load_file(file)
          @@config.merge!(data)
        end
      end
    end

    mattr_accessor :config
    @@config = {}

    # Read roles from files <tt>config/typus/*_roles.yml</tt>.
    def self.roles!
      files = Dir[File.join(Typus.config_folder, "*_roles.yml").to_s].sort

      @@roles = {}

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

    def self.models_constantized!
      @@models_constantized = config.map { |i| i.first }.inject({}) { |result, model| result[model] = model.constantize; result }
    end

    mattr_accessor :models_constantized

  end
end