module Typus
  module Generators
    class ConfigGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      class_option :admin_title, :default => Rails.root.basename

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

        models = Typus.application_models.reject { |m| Typus.models.include?(m) }
        models = models.map { |m| m.constantize }

        models.each do |model|
          configuration[model.table_name] = {}

          relationships = [ :has_many, :has_one ].map do |relationship|
                            model.reflect_on_all_associations(relationship).map { |i| i.name.to_s }
                          end.flatten

          rejections = %w( ^id$
                           created_at created_on updated_at updated_on deleted_at
                           salt crypted_password
                           password_salt persistence_token single_access_token perishable_token
                           _type$ type
                           _file_size$ )

          default_rejections = (rejections + %w( password password_confirmation )).join("|")
          form_rejections = (rejections + %w( position )).join("|")

          fields = model.columns.map(&:name)
          default = fields.reject { |f| f.match(default_rejections) }
          form = fields.reject { |f| f.match(form_rejections) }

          # We want attributes of belongs_to relationships to be shown in our
          # field collections if those are not polymorphic.
          [ default, form ].each do |fields|
            fields << model.reflect_on_all_associations(:belongs_to).reject { |i| i.options[:polymorphic] }.map { |i| i.name.to_s }
            fields.flatten!
          end

          configuration[model.table_name][:base] = <<-RAW
#{model}:
  fields:
    default: #{default.join(", ")}
    form: #{form.join(", ")}
  relationships: #{relationships.join(", ")}
  application: #{options[:admin_title]}
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
