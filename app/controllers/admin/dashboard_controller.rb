class Admin::DashboardController < AdminController

  def index
    raise "Run `script/rails generate typus` to create configuration files." if Typus.applications.empty?
  end

end
