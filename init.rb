require 'typus'

begin
  require 'fastercsv'
rescue LoadError
  puts "=> FasterCSV not available, CSV export from Typus won't work."
end

# Create needed controllers
Typus.generate_controllers unless RAILS_ENV == 'test'

# And finally we enable Typus
Typus.enable