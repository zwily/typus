
ActionController::Base.append_view_path(File.join(File.dirname(__FILE__), 'app', 'views'))

%w( models controllers helpers ).each do |folder|
  ActiveSupport::Dependencies.load_paths << File.join(File.dirname(__FILE__), 'app', folder)
end

require 'sha1'
require 'typus'

begin
  require 'fastercsv'
rescue LoadError
  puts "=> [typus] FasterCSV gem not installed. CSV export from Typus won't work."
end

##
# And finally we enable Typus
#
Typus.enable

##
# Autogenerator for the models.
#
Typus.generate_controllers unless RAILS_ENV == 'test'