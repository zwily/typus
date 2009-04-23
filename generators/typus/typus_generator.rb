class TypusGenerator < Rails::Generator::Base

  def manifest

    record do |m|

      ##
      # Default name for our application.
      #

      application = File.basename(Dir.pwd)

      ##
      # To create `application.yml` and `application_roles.yml` detect 
      # available AR models on the application.
      #

      models = Dir["#{Rails.root}/app/models/*.rb"].collect { |x| File.basename(x) }
      ar_models = []

      models.each do |model|
        class_name = model.sub(/\.rb$/,'').classify
        begin
          klass = class_name.constantize
          ar_models << klass if klass.superclass.equal?(ActiveRecord::Base)
        rescue Exception => error
          puts "=> [typus] #{error.message} on `#{class_name}`."
        end
      end

      ##
      # Configuration files
      #

      config_folder = Typus::Configuration.options[:config_folder]
      folder = "#{Rails.root}/#{config_folder}"
      Dir.mkdir(folder) unless File.directory?(folder)

      configuration = ""

      ar_models.each do |model|

        list = model.columns.reject { |c| c.sql_type == 'text' || %w( created_at updated_at ).include?(c.name) }.map(&:name)
        form = model.columns.reject { |c| %w( id created_at updated_at ).include?(c.name) }.map(&:name)
        relationships = [ :belongs_to, :has_and_belongs_to_many, :has_many ].map do |relationship|
                          model.reflect_on_all_associations(relationship).map { |i| i.name.to_s }
                        end.flatten.sort

        configuration << <<-HTML
#{model}:
  fields:
    list: #{list.join(', ')}
    form: #{form.join(', ')}
    relationship:
    options:
      auto_generated:
      read_only:
      selectors:
  actions:
    index:
    edit:
  export:
  order_by:
  relationships: #{relationships.join(', ')}
  filters:
  search:
  application: #{application}
  description:

        HTML

      end

      Dir["#{Typus.root}/generators/typus/templates/config/typus/*"].each do |f|
        base = File.basename(f)
        m.template "config/typus/#{base}", "#{config_folder}/#{base}", 
                   :assigns => { :configuration => configuration, :ar_models => ar_models }
      end

      ##
      # Initializers
      #

      m.template 'config/initializers/typus.rb', 'config/initializers/typus.rb', 
                 :assigns => { :application => application }

      ##
      # Public folders
      #

      [ "#{Rails.root}/public/stylesheets/admin", 
        "#{Rails.root}/public/javascripts/admin", 
        "#{Rails.root}/public/images/admin" ].each do |folder|
        Dir.mkdir(folder) unless File.directory?(folder)
      end

      m.file 'public/stylesheets/admin/screen.css', 'public/stylesheets/admin/screen.css'
      m.file 'public/stylesheets/admin/reset.css', 'public/stylesheets/admin/reset.css'
      m.file 'public/javascripts/admin/application.js', 'public/javascripts/admin/application.js'

      Dir["#{Typus.root}/generators/typus/templates/public/images/admin/*"].each do |f|
        base = File.basename(f)
        m.file "public/images/admin/#{base}", "public/images/admin/#{base}"
      end

      ##
      # Migration file
      #

      m.migration_template 'db/create_typus_users.rb', 'db/migrate', 
                            { :migration_file_name => 'create_typus_users' }

    end

  end

end