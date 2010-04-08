require 'rails/generators/migration'

class TypusGenerator < Rails::Generators::Base

  include Rails::Generators::Migration

  class_option :app_name, :default => Rails.root.basename
  class_option :user_class_name, :default => "TypusUser"
  class_option :user_fk, :default => "typus_user_id"

  def self.source_root
    @source_root ||= File.join(Typus.root, "generators", "typus", "templates")
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
      namespace = model.namespace

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

  def copy_migration_template
    migration_template "migration.rb", "db/migrate/create_#{admin_users_table_name}"
  end

  protected

  def inherits_from
    @inherits_from
  end

  def resource
    @resource
  end

  private

  def templates_path
    File.join(Typus.root, "generators", "typus", "templates")
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

end
