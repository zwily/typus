require 'ftools'

module Typus

  def self.magic_generator
    return if self.skip_magic_generator?
    self.prepare_folders
    self.generate_controllers_for_resources
    self.generate_controllers
  end

  ##
  # The magic generator won't run if:
  #
  # - We are on Heroku or in a production environment.
  # - We are not running `thin` or `script/server`.
  #
  def self.skip_magic_generator?

    return true if ENV['HEROKU'] || Rails.env.production?

    thin_command = `which thin`.chomp
    commands = [ thin_command, 'script/server' ].reject { |i| i.empty? }
    message = commands.include?($0) ? "will": "won't"
    puts "=> [typus] Automagic generation of files #{message} run."

    return !commands.include?($0)

  end

  def self.prepare_folders

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

  # Generate controllers for tableless models.
  def self.generate_controllers_for_resources

    resources.each do |resource|

      controller_filename = "#{resource.underscore}_controller.rb"
      controller_location = "#{@admin_controllers_folder}/#{controller_filename}"

      if !@admin_controllers.include?(controller_filename)
        template = File.read("#{File.dirname(__FILE__)}/templates/resource_controller.rb.erb")
        content = ERB.new(template).result(binding)
        File.open(controller_location, "w+") { |f| f << content }
      end

      # And now we create the view.
      view_folder = "#{@admin_views_folder}/#{resource.underscore}"
      view_filename = "index.html.erb"

      if !File.exist?("#{view_folder}/#{view_filename}")
        Dir.mkdir(view_folder) unless File.directory?(view_folder)
        origin = "#{File.dirname(__FILE__)}/templates/index.html.erb"
        destination = "#{view_folder}/#{view_filename}"
        File.copy(origin, destination)
      end

    end

  end

  ##
  # Generate:
  #   `app/controllers/admin/#{resource}_controller.rb`
  #   `test/functional/admin/#{resource}_controller_test.rb`
  #
  def self.generate_controllers

    models.each do |model|

      controller_filename = "#{model.tableize}_controller.rb"
      controller_location = "#{@admin_controllers_folder}/#{controller_filename}"

      if !@admin_controllers.include?(controller_filename)
        template = File.read("#{File.dirname(__FILE__)}/templates/resources_controller.rb.erb")
        content = ERB.new(template).result(binding)
        File.open(controller_location, "w+") { |f| f << content }
      end

      test_filename = "#{model.tableize}_controller_test.rb"
      test_location = "#{@admin_controller_tests_folder}/#{test_filename}"

      if !@admin_controller_tests.include?(test_filename) && File.directory?("#{Rails.root}/test")
        template = File.read("#{File.dirname(__FILE__)}/templates/resource_controller_test.rb.erb")
        content = ERB.new(template).result(binding)
        File.open(test_location, "w+") { |f| f << content }
      end

    end

  end

end