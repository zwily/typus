class Admin::ServiceController < AdminController

  before_filter :check_if_user_can_perform_action_on_service

  def index
  end

end
