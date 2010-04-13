module Typus

  module Templates

    def select_template(template, resource = @resource[:self])
      folder = (File.exist?("app/views/admin/#{resource}/#{template}.html.erb")) ? resource : 'resources'
      render "admin/#{folder}/#{template}"
    end

  end

end
