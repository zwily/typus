class Admin::DashboardController < Admin::BaseController

  def index
  end

  def show
    app_id = params[:application].parameterize
    render app_id
  rescue ActionView::MissingTemplate
    render "index"
  end

end
