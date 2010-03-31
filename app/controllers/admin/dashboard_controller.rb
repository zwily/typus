class Admin::DashboardController < AdminController

  def index
    flash[:notice] = _("There are not defined applications in config/typus/*.yml.") if Typus.applications.empty?
  end

end
