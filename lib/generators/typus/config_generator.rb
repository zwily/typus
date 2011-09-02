module Typus
  module Generators
    class ConfigGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc <<-MSG
Description:
  Creates configuration files and stores them in `config/typus`.

      MSG

      def generate_config
        copy_file "config/typus/README"
        generate_yaml.each do |key, value|
          if (@configuration = value)[:base].present?
            template "config/typus/application.yml", "config/typus/#{key}.yml"
            template "config/typus/application_roles.yml", "config/typus/#{key}_roles.yml"
          end
        end
      end

      protected

      def configuration
        @configuration
      end

      def generate_yaml
        Typus.reload!

        configuration = {}
        models = Typus.application_models.reject { |m| Typus.models.include?(m) }.map { |m| m.constantize }

        models.each do |model|
          configuration[model.table_name] = {}

          relationships = [ :has_many, :has_one ].map do |relationship|
                            model.reflect_on_all_associations(relationship).map { |i| i.name.to_s }
                          end.flatten.join(", ")

          rejections = %w( ^id$ _type$ type created_at created_on updated_at updated_on deleted_at ).join("|")
          fields = model.columns.map(&:name).reject { |f| f.match(rejections) }.join(", ")

          configuration[model.table_name][:base] = <<-RAW
#{model}:
  fields:
    default: #{fields}
    form: #{fields}
  relationships: #{relationships}
  application: Application
          RAW

          configuration[model.table_name][:roles] = <<-RAW
  #{model}: create, read, update, delete
          RAW

        end

        configuration
      end

    end
  end
end
