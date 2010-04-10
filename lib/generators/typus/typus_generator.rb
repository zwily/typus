require "rails/generators/migration"

class TypusGenerator < Rails::Generators::Base

  include Rails::Generators::Migration

  class_option :app_name, :default => Rails.root.basename
  class_option :user_class_name, :default => "TypusUser"
  class_option :user_fk, :default => "typus_user_id"

  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def generate_configuration_files
    %w( README typus.yml typus_roles.yml ).each do |file|
      from = to = "config/typus/#{file}"
      template from, to
    end
  end

  def copy_initializer_file
    template "initializer.rb", "config/initializers/typus.rb"
  end

  def copy_assets
    Dir["#{templates_path}/public/**/*.*"].each do |file|
      copy_file file.split("#{templates_path}/").last
    end
  end

  def add_typus_routes
    route "Typus::Routes.draw(map)"
  end

  ##
  # Generate files for models:
  #   `#{controllers_path}/#{resource}_controller.rb`
  #   `#{tests_path}/#{resource}_controller_test.rb`
  #   `#{views_path}/#{resource}/<action>.html.erb`
  #
  def generate_controllers_for_models

    (Typus.application_models + [options[:user_class_name]]).each do |model|

      klass = model.constantize

      @inherits_from = "Admin::MasterController"
      @resource = klass.name.pluralize

      template "controller.rb", 
               "#{controllers_path}/#{klass.name.tableize}_controller.rb"


      template "functional_test.rb", 
               "#{tests_path}/#{klass.name.tableize}_controller_test.rb"

      next if klass.name == options[:user_class_name]

      klass.typus_actions.each do |action|
        file "view.html.erb", "#{views_path}/#{klass.name.tableize}/#{action}.html.erb"
      end

    end

  end

  ##
  # Generate files for tableless models:
  #   `#{controllers_path}/#{resource}_controller.rb`
  #   `#{tests_path}/#{resource}_controller_test.rb`
  #   `#{views_path}/#{resource}/<action>.html.erb`
  #
  def generate_controllers_for_services

    Typus.resources.each do |resource|

      @inherits_from = "Admin::ServiceController"
      @resource = resource
      @sidebar = <<-HTML
<% content_for :sidebar do %>
<%= render "admin/dashboard/sidebar" %>
<% end %>
      HTML

      template "controller.rb", 
               "#{controllers_path}/#{resource.underscore}_controller.rb"

      template "functional_test.rb", 
               "#{tests_path}/#{resource.underscore}_controller_test.rb"

      template "view.html.erb", 
               "#{views_path}/#{resource.underscore}/index.html.erb"

    end

  end

  def generate_config_files
    configuration = generate_yaml_files
    if !configuration[:base].empty?
      %w( application.yml application_roles.yml ).each do |file|
        from = to = "config/typus/#{file}"
        if File.exists?(from) then to = "config/typus/#{timestamp}_#{file}" end
        @configuration = configuration
        template from, to
      end
    end
  end

  def copy_migration_template
    migration_template "migration.rb", "db/migrate/create_#{admin_users_table_name}"
  end

  protected

  def configuration
    @configuration
  end

  def inherits_from
    @inherits_from
  end

  def resource
    @resource
  end

  def sidebar
    @sidebar
  end

  private

  def templates_path
    File.join(Typus.root, "lib", "generators", "typus", "templates")
  end

  def admin_users_table_name
    options[:user_class_name].tableize
  end

  def migration_name
    "Create#{options[:user_class_name]}s"
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

  def timestamp
    timestamp = Time.now.utc.to_s(:number)
  end

  def generate_yaml_files

    configuration = { :base => "", :roles => "" }

    Typus.application_models.sort { |x,y| x <=> y }.each do |model|

      next if Typus.models.include?(model)

      klass = model.constantize

      # Detect all relationships except polymorphic belongs_to using reflection.
      relationships = [ :belongs_to, :has_and_belongs_to_many, :has_many, :has_one ].map do |relationship|
                        klass.reflect_on_all_associations(relationship).reject { |i| i.options[:polymorphic] }.map { |i| i.name.to_s }
                      end.flatten.sort

      ##
      # Model field defaults for:
      #
      # - List
      # - Form
      #

      rejections = %w( ^id$ 
                       created_at created_on updated_at updated_on 
                       salt crypted_password 
                       password_salt persistence_token single_access_token perishable_token 
                       _type$ )

      list_rejections = rejections + %w( password password_confirmation )
      form_rejections = rejections + %w( position )

      list = klass.columns.reject do |column|
               column.name.match(list_rejections.join("|")) || column.sql_type == "text"
             end.map(&:name)

      form = klass.columns.reject do |column|
               column.name.match(form_rejections.join("|"))
             end.map(&:name)

      # Model defaults.
      order_by = "position" if list.include?("position")
      filters = "created_at" if klass.columns.include?("created_at")
      search = ( [ "name", "title" ] & list ).join(", ")

      # We want attributes of belongs_to relationships to be shown in our 
      # field collections if those are not polymorphic.
      [ list, form ].each do |fields|
        fields << klass.reflect_on_all_associations(:belongs_to).reject { |i| i.options[:polymorphic] }.map { |i| i.name.to_s }
        fields.flatten!
      end

      configuration[:base] << <<-RAW
#{klass}:
  fields:
    list: #{list.join(", ")}
    form: #{form.join(", ")}
  order_by: #{order_by}
  relationships: #{relationships.join(", ")}
  filters: #{filters}
  search: #{search}
  application: #{options[:app_name]}

      RAW

      configuration[:roles] << <<-RAW
  #{klass}: create, read, update, delete
      RAW

    end

    return configuration

  end

end
