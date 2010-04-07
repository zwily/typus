require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands")
require File.expand_path(File.dirname(__FILE__) + "/lib/string")

class TypusGenerator < Rails::Generator::Base

  default_options :app_name => Rails.root.basename, 
                  :user_class_name => "TypusUser",
                  :user_fk => "typus_user_id"

  def manifest

    ##
    # Define variables.
    #

    timestamp = Time.now.utc.to_s(:number)
    controllers_path = "app/controllers/admin"
    tests_path = "test/functional/admin"
    views_path = "app/views/admin"

    record do |m|

      ##
      # Create required folders.
      #

      [ controllers_path, 
        views_path, 
        "config/typus", 
        "public/images/admin/fancybox", 
        "public/javascripts/admin", 
        "public/stylesheets/admin", 
        tests_path ].each { |folder| m.directory folder }

      ##
      # To create <tt>application.yml</tt> and <tt>application_roles.yml</tt> 
      # detect available AR models on the application.
      #

      configuration = { :base => "", :roles => "" }

      Typus.application_models.sort { |x,y| x <=> y }.each do |model|

        next if Typus.models.include?(model.name)

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

        reject_columns = []

        klass.reflect_on_all_associations(:belongs_to).each do |i|
          reject_columns << klass.columns_hash[i.name.to_s + "_id"]
          reject_columns << klass.columns_hash[i.name.to_s + "_type"] if i.options[:polymorphic]
        end

        model_columns = klass.columns - reject_columns

        rejections = %w( id created_at created_on updated_at updated_on 
                         salt crypted_password 
                         password_salt persistence_token single_access_token perishable_token )

        list_rejections = rejections + %w( password password_confirmation )
        form_rejections = rejections + %w( position )

        list = model_columns.reject { |c| c.sql_type == "text" || list_rejections.include?(c.name) }.map(&:name)
        form = model_columns.reject { |c| form_rejections.include?(c.name) }.map(&:name)

        ##
        # Model defaults:
        #
        # - Order
        # - Filters
        # - Search
        #

        order_by = "position" if list.include?("position")
        filters = "created_at" if model_columns.include?("created_at")
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

      if !configuration[:base].empty?

        %w( application.yml application_roles.yml ).each do |file|
          from = to = "config/typus/#{file}"
          if File.exists?(from) then to = "config/typus/#{timestamp}_#{file}" end
          m.template from, to, :assigns => { :configuration => configuration }
        end

      end

      %w( README typus.yml typus_roles.yml ).each do |file|
        from = to = "config/typus/#{file}"
        m.template from, to, :assigns => { :configuration => configuration }
      end

      ##
      # Initializer
      #

      if !options[:user_class_name].eql?("TypusUser")
        options[:user_fk] = options[:user_class_name].foreign_key if options[:user_fk].eql?("typus_user_id")
      end

      m.template "initializer.rb", "config/initializers/typus.rb"

      ##
      # Assets: images, javascripts & stylesheets
      #

      %w( public/images/admin/ui-icons.png ).each { |f| m.file f, f }

      Dir["#{Typus.root}/generators/typus/templates/public/stylesheets/admin/*"].each do |file|
        from = to = "public/stylesheets/admin/#{File.basename(file)}"
        m.file from, to
      end

      Dir["#{Typus.root}/generators/typus/templates/public/javascripts/admin/*"].each do |file|
        from = to = "public/javascripts/admin/#{File.basename(file)}"
        m.file from, to
      end

      Dir["#{Typus.root}/generators/typus/templates/public/images/admin/fancybox/*"].each do |file|
        from = to = "public/images/admin/fancybox/#{File.basename(file)}"
        m.file from, to
      end

      ##
      # Generate:
      #   `#{controllers_path}/#{resource}_controller.rb`
      #   `#{tests_path}/#{resource}_controller_test.rb`
      #   `#{views_path}/#{resource}/<action>.html.erb`
      #

      (Typus.application_models + [options[:user_class_name]]).each do |model|

        klass = model.constantize
        namespace = model.namespace

        assigns = { :inherits_from => "Admin::MasterController", 
                    :resource => klass.name.pluralize }

        m.directory "#{controllers_path}/#{namespace}"
        m.template "controller.rb", 
                   "#{controllers_path}/#{klass.name.tableize}_controller.rb", 
                   :assigns => assigns

        m.directory "#{tests_path}/#{namespace}"
        m.template "functional_test.rb", 
                   "#{tests_path}/#{klass.name.tableize}_controller_test.rb", 
                   :assigns => assigns

        next if klass.name == options[:user_class_name]

        m.directory "#{views_path}/#{klass.name.tableize}"
        klass.typus_actions.each do |action|
          m.file "view.html.erb", "#{views_path}/#{klass.name.tableize}/#{action}.html.erb"
        end

      end

      ##
      # Generate files for tableless models:
      #   `#{controllers_path}/#{resource}_controller.rb`
      #   `#{tests_path}/#{resource}_controller_test.rb`
      #   `#{views_path}/#{resource}/<action>.html.erb`
      #

      Typus.resources.each do |resource|

        namespace = resource.namespace

        sidebar = <<-HTML
<% content_for :sidebar do %>
  <%= render "admin/dashboard/sidebar" %>
<% end %>
        HTML

        assigns = { :inherits_from => "Admin::ServiceController", 
                    :resource => resource, 
                    :sidebar => sidebar }

        m.directory "#{controllers_path}/#{namespace}"
        m.template "controller.rb", 
                   "#{controllers_path}/#{resource.underscore}_controller.rb", 
                   :assigns => assigns

        m.directory "#{tests_path}/#{namespace}"
        m.template "functional_test.rb", 
                   "#{tests_path}/#{resource.underscore}_controller_test.rb", 
                   :assigns => assigns

        m.directory "#{views_path}/#{resource.underscore}"
        m.template "view.html.erb", 
                   "#{views_path}/#{resource.underscore}/index.html.erb", 
                   :assigns => assigns

      end

      ##
      # Generate the model file if it's custom.
      #

      unless options[:user_class_name] == 'TypusUser'
        m.template "model.rb", "app/models/#{options[:user_class_name].underscore}.rb"
      end

      ##
      # Typus Route
      #

      m.insert_into "config/routes.rb", "Typus::Routes.draw(map)"

      ##
      # Migration file
      #

      m.migration_template "migration.rb", 
                           "db/migrate", 
                            :assigns => { :migration_name => "Create#{options[:user_class_name]}s", 
                                          :typus_users_table_name => options[:user_class_name].tableize }, 
                            :migration_file_name => "create_#{options[:user_class_name].tableize}"

    end

  end

  def banner
    "Usage: #{$0} #{spec.name}"
  end

  def add_options!(opt)

    opt.separator ""
    opt.separator "Options:"

    opt.on("-u", "--typus_user=Class", String,
           "Configure Typus User class name. Default is `#{default_options[:user_class_name]}`.") { |v| options[:user_class_name] = v }

    opt.on("-a", "--app_name=ApplicationName", String,
           "Set an application name. Default is `#{default_options[:app_name]}`.") { |v| options[:app_name] = v }

    opt.on("-k", "--user_fk=UserFK", String,
           "Configure Typus User foreign key field. Default is `#{default_options[:user_fk]}`.") { |v| options[:user_fk] = v }

  end

end
