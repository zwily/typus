class TypusFilesGenerator < Rails::Generator::Base

  def manifest

    record do |m|

      ##
      # For creating `typus.yml` and `typus_roles.yml` we need first to detect 
      # the available AR models.
      #
      Dir.chdir(File.join(RAILS_ROOT, "app/models"))
      models, ar_models = Dir["*.rb"], []

      models.each do |model|
        class_name = eval model.sub(/\.rb$/,'').camelize
        if class_name.superclass.to_s.include?("ActiveRecord::Base")
          ar_models << class_name
        end
      end

      # configuration files
      files = %w( typus.yml typus_roles.yml )
      files.each do |file|
        m.template "config/#{file}", "config/#{file}", :assigns => { :ar_models => ar_models }
      end

      # stylesheets and images
      m.file "stylesheets/typus.css", "public/stylesheets/typus.css"
      files = %w( typus_spinner.gif typus_trash.gif typus_status_false.gif typus_status_true.gif )
      files.each { |file| m.file "images/#{file}", "public/images/#{file}" }

    end

  end

end