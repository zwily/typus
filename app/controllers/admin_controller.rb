class AdminController < ActionController::Base

  unloadable

  include Typus::Authentication
  include Typus::Preferences
  include Typus::Reloader

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, :with => :render_error
  end

  if Typus::Configuration.options[:ssl]
    include SslRequirement
    ssl_required :all
  end

  before_filter :reload_config_and_roles
  before_filter :authenticate
  before_filter :set_preferences
  before_filter :set_page_title

  def index
    redirect_to admin_dashboard_path
  end

  protected

  def render_error(exception)
    log_error(exception)
    flash[:error] = exception.message
    redirect_to admin_path
  end

  def set_page_title
    @page_title = []
    @page_title << _(params[:controller].sub("admin/", "").humanize)
    @page_title << _(params[:action].humanize) unless params[:action].eql?("index")
  end

end
