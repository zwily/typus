begin

  ##
  # Add Typus views ...
  #
  ActionController::Base.append_view_path(File.join(File.dirname(__FILE__), 'app', 'views'))

  ##
  # Add Typus controllers, models and helpers ...
  #
  %w( controllers models helpers ).each do |m|
    Dependencies.load_paths << File.join(File.dirname(__FILE__), 'app', m)
  end

  ##
  # Required gems and files.
  #
  %w( sha1 paginator typus ).each { |lib| require lib }

  ##
  # And finally we enable Typus
  #
  Typus.enable

rescue LoadError
  puts "=> [TYPUS] Install required plugins and gems with `rake typus:dependencies`"
end