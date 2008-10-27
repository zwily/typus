
ActionController::Base.append_view_path(File.join(File.dirname(__FILE__), 'app', 'views'))

%w( models controllers helpers ).each do |m|
  ActiveSupport::Dependencies.load_paths << File.join(File.dirname(__FILE__), 'app', m)
end

require 'typus'

begin
  require 'fastercsv'
rescue LoadError
  puts "[typus] FasterCSV gem not installed. CSV export from Typus won't work."
end

# Create needed controllers
Typus.generate_controllers unless RAILS_ENV == 'test'

# And finally we enable Typus
Typus.enable