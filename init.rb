##
# Add Typus views ...
#
ActionController::Base.append_view_path(File.join(File.dirname(__FILE__), 'app', 'views'))

##
# Add Typus controllers, models and helpers ...
#
%w( controllers models helpers ).each do |m|
  ActiveSupport::Dependencies.load_paths << File.join(File.dirname(__FILE__), 'app', m)
end

##
# Required gems and files.
#
%w( sha1 typus ).each { |lib| require lib }

##
# And finally we enable Typus
#
Typus.enable