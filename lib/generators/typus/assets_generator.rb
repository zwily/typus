module Typus

  module Generators

    class AssetsGenerator < Rails::Generators::Base

      source_root File.expand_path("../../templates", __FILE__)

      desc <<-MSG
Description:
  Copies all Typus assets to your application.

      MSG

      def copy_assets
        Dir["#{source_root}/public/**/*.*"].each do |file|
          copy_file file.split("#{source_root}/").last
        end
      end

    end

  end

end
