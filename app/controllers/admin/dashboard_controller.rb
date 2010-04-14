class Admin::DashboardController < AdminController

  def show
    raise "Run `script/rails generate typus` to create configuration files." if Typus.applications.empty?
  end

end
