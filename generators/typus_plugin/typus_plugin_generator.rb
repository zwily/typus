class TypusPluginGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|

      # Lib
      m.directory "vendor/plugins/#{file_name}/lib/#{file_name}"
      m.file "lib/routes.rb", "vendor/plugins/#{file_name}/lib/#{file_name}/routes.rb"

      # Files
      m.directory "vendor/plugins/#{file_name}/config"
      m.file "config/typus.yml.tpl", "vendor/plugins/#{file_name}/config/typus.yml.template"
      m.file "config/typus_roles.yml.template", "vendor/plugins/#{file_name}/config/typus_roles.yml.template"

    end

  end

protected

  def banner
    "Usage: #{$0} #{spec.name} PluginName"
  end

end
