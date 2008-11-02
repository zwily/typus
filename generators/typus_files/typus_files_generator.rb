class TypusFilesGenerator < Rails::Generator::Base

  def manifest

    record do |m|

      application = RAILS_ROOT.split("/").last

      ##
      # For creating `typus.yml` and `typus_roles.yml` we need first to detect 
      # the available AR models of the application, not the plugins.
      #
      Dir.chdir(File.join(RAILS_ROOT, "app/models"))
      models, ar_models = Dir["*.rb"], []

      models.each do |model|
        class_name = eval model.sub(/\.rb$/,'').camelize
        if class_name.superclass.to_s.include?("ActiveRecord::Base")
          ar_models << class_name
        end
      end

      ##
      # configuration files
      #
      files = %w( typus.yml typus_roles.yml )
      files.each do |file|
        m.template "config/#{file}", 
                   "config/#{file}", 
                   :assigns => { :ar_models => ar_models, :application => application }
      end

      # initializers
      m.template "initializers/typus.rb", 
                 "config/initializers/typus.rb", 
                 :assigns => { :application => application }

      ["#{RAILS_ROOT}/public/stylesheets/admin", 
      "#{RAILS_ROOT}/public/images/admin" ].each do |folder|
        Dir.mkdir(folder) unless File.directory?(folder)
      end

      # stylesheets and images
      m.file "stylesheets/admin/screen.css", "public/stylesheets/admin/screen.css"
      files = %w( spinner.gif trash.gif status_false.gif status_true.gif )
      files.each { |file| m.file "images/admin/#{file}", "public/images/admin/#{file}" }

    end

  end

end