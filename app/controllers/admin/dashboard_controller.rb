class Admin::DashboardController < AdminController

  def dashboard
    flash[:notice] = _("There are not defined applications in config/typus/*.yml.") if Typus.applications.empty?
  end

end
