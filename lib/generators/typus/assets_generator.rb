module Typus

  module Generators

    class AssetsGenerator < Rails::Generators::Base

      desc <<-MSG
Description:
  Copies all Typus assets to your application.

      MSG

      def copy_assets
        templates_path = File.join(Typus.root, "lib", "generators", "templates")

        Dir["#{templates_path}/public/**/*.*"].each do |file|
          copy_file file.split("#{templates_path}/").last
        end
      end

    end

  end

end
