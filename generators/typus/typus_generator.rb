class TypusGenerator < Rails::Generator::Base

  def manifest

    record do |m|

      # Default name for our application.
      application = Rails.root.basename

      # To create <tt>application.yml</tt> and <tt>application_roles.yml</tt> 
      # detect available AR models on the application.
      models = Dir['app/models/*.rb'].collect { |x| File.basename(x).sub(/\.rb$/,'').camelize }
      @ar_models = []

      models.each do |model|
        begin
          klass = model.constantize
          active_record_model = klass.superclass.equal?(ActiveRecord::Base) && !klass.abstract_class?
          active_record_model_with_sti = klass.superclass.superclass.equal?(ActiveRecord::Base)
          @ar_models << klass if active_record_model || active_record_model_with_sti
        rescue Exception => error
          puts "=> [typus] #{error.message} on '#{model.class.name}'."
          exit
        end
      end

      # Configuration files
      config_folder = Typus::Configuration.options[:config_folder]
      Dir.mkdir(config_folder) unless File.directory?(config_folder)

      configuration = { :base => '', :roles => '' }

      @ar_models.sort{ |x,y| x.class_name <=> y.class_name }.each do |model|

        # Detect all relationships except polymorphic belongs_to using reflection.
        relationships = [ :belongs_to, :has_and_belongs_to_many, :has_many, :has_one ].map do |relationship|
                          model.reflect_on_all_associations(relationship).reject { |i| i.options[:polymorphic] }.map { |i| i.name.to_s }
                        end.flatten.sort

        # Remove foreign key and polymorphic type attributes
        reject_columns = []
        model.reflect_on_all_associations(:belongs_to).each do |i|
          reject_columns << model.columns_hash[i.name.to_s + '_id']
          reject_columns << model.columns_hash[i.name.to_s + '_type'] if i.options[:polymorphic]
        end

        model_columns = model.columns - reject_columns

        # Don't show `text` fields and timestamps in lists.
        list = model_columns.reject { |c| c.sql_type == 'text' || %w( id created_at updated_at ).include?(c.name) }.map(&:name)
        # Don't show timestamps in forms.
        form = model_columns.reject { |c| %w( id created_at updated_at ).include?(c.name) }.map(&:name)
        # Show all model columns in the show action.
        show = model_columns.map(&:name)

        # We want attributes of belongs_to relationships to be shown in our 
        # field collections if those are not polymorphic.
        [ list, form, show ].each do |fields|
          fields << model.reflect_on_all_associations(:belongs_to).reject { |i| i.options[:polymorphic] }.map { |i| i.name.to_s }
          fields.flatten!
        end

        configuration[:base] << <<-RAW
#{model}:
  fields:
    list: #{list.join(', ')}
    form: #{form.join(', ')}
    show: #{show.join(', ')}
  actions:
    index:
    edit:
  order_by:
  relationships: #{relationships.join(', ')}
  filters:
  search:
  application: #{application}
  description:

        RAW

        configuration[:roles] << <<-RAW
  #{model}: create, read, update, delete
        RAW

      end

      Dir["#{Typus.root}/generators/typus/templates/config/typus/*"].each do |f|
        base = File.basename(f)
        m.template "config/typus/#{base}", "#{config_folder}/#{base}", 
                   :assigns => { :configuration => configuration }
      end

      # Initializer

      [ 'config/initializers/typus.rb' ].each do |initializer|
        m.template initializer, initializer, :assigns => { :application => application }
      end

      # Assets

      [ 'public/stylesheets/admin', 
        'public/javascripts/admin', 
        'public/images/admin', 
        'public/images/admin/fancybox' ].each { |f| Dir.mkdir(f) unless File.directory?(f) }

      [ 'public/stylesheets/admin/screen.css', 
        'public/stylesheets/admin/reset.css', 
        'public/stylesheets/admin/jquery.fancybox.css', 
        'public/images/admin/ui-icons.png' ].each { |f| m.file f, f }

      %w( application jquery-1.3.2.min jquery.fancybox-1.2.1.min ).each do |f|
        file = "public/javascripts/admin/#{f}.js"
        m.file file, file
      end

      %w( closebox left progress right shadow_e shadow_n shadow_ne shadow_nw shadow_s shadow_se shadow_sw shadow_w title_left title_main title_right ).each do |image|
        file = "public/images/admin/fancybox/fancy_#{image}.png"
        m.file file, file
      end

      # Migration file

      m.migration_template 'db/create_typus_users.rb', 'db/migrate', 
                            { :migration_file_name => 'create_typus_users' }

      prepare_folders
      generate_controllers
      generate_controllers_for_resources

    end

  end

  def prepare_folders

    # Create needed folders if doesn't exist.
    @admin_controllers_folder = "#{Rails.root}/app/controllers/admin"
    @admin_views_folder = "#{Rails.root}/app/views/admin"

    [ @admin_controllers_folder, @admin_views_folder ].each do |folder|
      Dir.mkdir(folder) unless File.directory?(folder)
    end

    # Create test/functional/admin if doesn't exist.
    @admin_controller_tests_folder = "#{Rails.root}/test/functional/admin"
    if File.directory?("#{Rails.root}/test")
      Dir.mkdir(@admin_controller_tests_folder) unless File.directory?(@admin_controller_tests_folder)
    end

    # Get a list of controllers under `app/controllers/admin`.
    @admin_controllers = Dir["#{Rails.root}/vendor/plugins/*/app/controllers/admin/*.rb", 
                             "#{@admin_controllers_folder}/*.rb"].map { |i| File.basename(i) }

    # Get a list of functional tests under `test/functional/admin`.
    @admin_controller_tests = Dir["#{@admin_controller_tests_folder}/*.rb"].map { |i| File.basename(i) }

  end

  ##
  # Generate:
  #   `app/controllers/admin/#{resource}_controller.rb`
  #   `test/functional/admin/#{resource}_controller_test.rb`
  #
  def generate_controllers

    Typus.models.each do |model|

      controller_filename = "#{model.tableize}_controller.rb"
      controller_location = "#{@admin_controllers_folder}/#{controller_filename}"

      if !@admin_controllers.include?(controller_filename)
        template = File.read("#{File.dirname(__FILE__)}/templates/auto/resources_controller.rb.erb")
        content = ERB.new(template).result(binding)
        File.open(controller_location, "w+") { |f| f << content }
      end

      test_filename = "#{model.tableize}_controller_test.rb"
      test_location = "#{@admin_controller_tests_folder}/#{test_filename}"

      if !@admin_controller_tests.include?(test_filename) && File.directory?("#{Rails.root}/test")
        template = File.read("#{File.dirname(__FILE__)}/templates/auto/resource_controller_test.rb.erb")
        content = ERB.new(template).result(binding)
        File.open(test_location, "w+") { |f| f << content }
      end

    end

  end

  # Generate controllers for tableless models.
  def generate_controllers_for_resources

    Typus.resources.each do |resource|

      controller_filename = "#{resource.underscore}_controller.rb"
      controller_location = "#{@admin_controllers_folder}/#{controller_filename}"

      if !@admin_controllers.include?(controller_filename)
        template = File.read("#{File.dirname(__FILE__)}/templates/auto/resource_controller.rb.erb")
        content = ERB.new(template).result(binding)
        File.open(controller_location, "w+") { |f| f << content }
      end

      # And now we create the view.
      view_folder = "#{@admin_views_folder}/#{resource.underscore}"
      view_filename = "index.html.erb"

      if !File.exist?("#{view_folder}/#{view_filename}")
        Dir.mkdir(view_folder) unless File.directory?(view_folder)
        origin = "#{File.dirname(__FILE__)}/templates/auto/index.html.erb"
        destination = "#{view_folder}/#{view_filename}"
        File.copy(origin, destination)
      end

    end

  end

end