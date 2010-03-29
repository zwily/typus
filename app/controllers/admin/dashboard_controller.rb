class Admin::DashboardController < AdminController

  layout 'admin'

  before_filter :require_login
  before_filter :set_typus_preferences

  def dashboard
    flash[:notice] = _("There are not defined applications in config/typus/*.yml.") if Typus.applications.empty?
  end

end
