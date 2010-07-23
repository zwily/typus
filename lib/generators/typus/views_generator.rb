module Typus

  module Generators

    class ViewsGenerator < Rails::Generators::Base

      source_root File.expand_path("../../../../app/views", __FILE__)

      desc <<-MSG
Description:
  Copies all Typus views to your application.

      MSG

      def copy_views
        directory "admin", "app/views/admin"
        directory "layouts/admin", "app/views/layouts/admin"
      end

    end

  end

end
