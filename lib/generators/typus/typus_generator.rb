require "rails/generators/migration"

module Typus

  module Generators

    class TypusGenerator < Rails::Generators::Base

      include Rails::Generators::Migration

      source_root File.expand_path("../../templates", __FILE__)

      namespace "typus"

      class_option :admin_title, :default => Rails.root.basename

      desc <<-DESC
Description:
  This generator creates required files to enable an admin panel which allows
  trusted users to edit structured content.

  To enable session authentication run `rails g typus:migration`.

      DESC

      def self.next_migration_number(path)
        Time.zone.now.utc.to_s(:number)
      end

      def copy_config_readme
        copy_file "config/typus/README"
      end

      def generate_initializer
        template "config/initializers/typus.rb", "config/initializers/typus.rb"
        template "config/initializers/typus_resources.rb", "config/initializers/typus_resources.rb"
      end

      def copy_assets
        Dir["#{templates_path}/public/**/*.*"].each do |file|
          copy_file file.split("#{templates_path}/").last
        end
      end

      #--
      # Generate files for models:
      #   `#{controllers_path}/#{resource}_controller.rb`
      #   `#{tests_path}/#{resource}_controller_test.rb`
      #++
      def generate_controllers
        Typus.application_models.each do |model|
          klass = model.constantize
          @resource = klass.name.pluralize
          template "controller.rb", "#{controllers_path}/#{klass.to_resource}_controller.rb"
          template "functional_test.rb", "#{tests_path}/#{klass.to_resource}_controller_test.rb"
        end
      end

      def generate_application_yaml
        configuration = generate_yaml_files

        return if configuration[:base].empty?

        file = "config/typus/application.yml"
        template file, file unless File.exists?(file)

        append_file file, configuration[:base]
      end

      def generate_application_roles_yaml
        configuration = generate_yaml_files

        return if configuration[:roles].empty?

        file = "config/typus/application_roles.yml"
        template file, file unless File.exists?(file)

        append_file file, configuration[:roles]
      end

      protected

      def inherits_from
        "Admin::ResourcesController"
      end

      def resource
        @resource
      end

      def sidebar
        @sidebar
      end

      private

      def templates_path
        File.join(Typus.root, "lib", "generators", "templates")
      end

      def controllers_path
        "app/controllers/admin"
      end

      def tests_path
        "test/functional/admin"
      end

      def views_path
        "app/views/admin"
      end

      def generate_yaml_files
        configuration = {}

        configuration[:base] = ""
        configuration[:roles] = <<-RAW
admin:
        RAW

        Typus.application_models.sort { |x,y| x <=> y }.each do |model|

          next if Typus.models.include?(model)

          klass = model.constantize

          # Detect all relationships except polymorphic belongs_to using reflection.
          relationships = [ :belongs_to, :has_and_belongs_to_many, :has_many, :has_one ].map do |relationship|
                            klass.reflect_on_all_associations(relationship).reject { |i| i.options[:polymorphic] }.map { |i| i.name.to_s }
                          end.flatten.sort

          ##
          # Model fields for:
          #
          # - Default
          # - Form
          #

          rejections = %w( ^id$
                           created_at created_on updated_at updated_on deleted_at
                           salt crypted_password
                           password_salt persistence_token single_access_token perishable_token
                           _type$
                           _file_size$ )

          default_rejections = rejections + %w( password password_confirmation )
          form_rejections = rejections + %w( position )

          default = klass.columns.reject do |column|
                   column.name.match(default_rejections.join("|")) || column.sql_type == "text"
                 end.map(&:name)

          form = klass.columns.reject do |column|
                   column.name.match(form_rejections.join("|"))
                 end.map(&:name)

          # Model defaults.
          order_by = "position" if default.include?("position")
          filters = "created_at" if klass.columns.include?("created_at")
          search = ( %w(name title) & default ).join(", ")

          # We want attributes of belongs_to relationships to be shown in our
          # field collections if those are not polymorphic.
          [ default, form ].each do |fields|
            fields << klass.reflect_on_all_associations(:belongs_to).reject { |i| i.options[:polymorphic] }.map { |i| i.name.to_s }
            fields.flatten!
          end

          configuration[:base] << <<-RAW
#{klass}:
  fields:
    default: #{default.join(", ")}
    form: #{form.join(", ")}
  order_by: #{order_by}
  relationships: #{relationships.join(", ")}
  filters: #{filters}
  search: #{search}
  application: #{options[:admin_title]}

          RAW

          configuration[:roles] << <<-RAW
  #{klass}: create, read, update, delete
          RAW

        end

        return configuration

      end

    end

  end

end
