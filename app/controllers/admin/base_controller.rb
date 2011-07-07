class Admin::BaseController < ActionController::Base

  include Typus::Authentication::const_get(Typus.authentication.to_s.classify)

  before_filter :reload_config_and_roles
  before_filter :authenticate
  before_filter :set_locale

  helper_method :admin_user

  def user_guide
  end

  protected

  def reload_config_and_roles
    Typus.reload! unless Rails.env.production?
  end

  def set_locale
    I18n.locale = if admin_user && admin_user.respond_to?(:locale)
                    admin_user.locale
                  else
                    Typus::I18n.default_locale
                  end
  end

  def zero_users
    Typus.user_class.count.zero?
  end

end
