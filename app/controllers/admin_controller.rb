require "typus/authentication"

class AdminController < ActionController::Base

  unloadable

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_error
  end

  before_filter :reload_config_and_roles
  before_filter :authenticate

  def show
    redirect_to admin_dashboard_path
  end

  protected

  def render_error(exception)
    # log_error(exception)
    redirect_to admin_path, :alert => exception.message
  end

  def reload_config_and_roles
    Typus.reload! unless Rails.env.production?
  end

  include Typus::Authentication

  def set_path
    @back_to || request.referer || admin_dashboard_path
  end

end
