class AdminController < ActionController::Base

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
  before_filter :require_login
  before_filter :set_typus_preferences

  def index
    redirect_to admin_dashboard_path
  end

  protected

  def error_handler(error, path = admin_dashboard_path)
    raise error unless Rails.env.production?
    flash[:error] = "#{error.message} (#{@resource[:class]})"
    redirect_to path
  end

end
