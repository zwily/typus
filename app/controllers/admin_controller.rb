class AdminController < ActionController::Base

  # layout :select_layout

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

  protected

  def error_handler(error, path = admin_dashboard_path)
    raise error unless Rails.env.production?
    flash[:error] = "#{error.message} (#{@resource[:class]})"
    redirect_to path
  end

=begin

  def select_layout
    %w( sign_up sign_in sign_out 
        recover_password reset_password ).include?(action_name) ? "login" : "admin"
  end

=end

end
