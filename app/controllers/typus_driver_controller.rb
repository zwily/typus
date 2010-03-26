class TypusDriverController < ActionController::Base

  unloadable
  filter_parameter_logging :password

  include Typus::Authentication
  include Typus::Preferences
  include Typus::Reloader

  if Typus::Configuration.options[:ssl]
    include SslRequirement
    ssl_required :all
  end

  before_filter :reload_config_and_roles


end