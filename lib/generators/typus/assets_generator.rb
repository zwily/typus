module Typus

  module Generators

    class AssetsGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc <<-MSG
Description:
  Copies all Typus assets to your application.

      MSG

      def demo
        directory "public", "public"
      end

    end

  end

end
