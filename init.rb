
ActionController::Base.append_view_path(File.join(File.dirname(__FILE__), 'app', 'views'))

%w( models controllers helpers ).each do |folder|
  ActiveSupport::Dependencies.load_paths << File.join(File.dirname(__FILE__), 'app', folder)
end

require 'typus'

##
# We don't want to enable or generate files if we are running a generator
#
scripts = %w( script/generate script/destroy )

##
# Enable Typus and run the generator unless we are on Rails.env.test?
#
unless scripts.include?($0)
  Typus.enable
  Typus.generator unless Rails.env.test?
end