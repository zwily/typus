require "typus/authentication"

class Admin::BaseController < ActionController::Base

  unloadable

  before_filter :reload_config_and_roles
  before_filter :authenticate

  protected

  def reload_config_and_roles
    Typus.reload! unless Rails.env.production?
  end

  include Typus::Authentication
  helper_method :current_user

  def set_path
    @back_to || request.referer || admin_dashboard_path
  end

end
