require "test/test_helper"

class Admin::DashboardControllerTest < ActionController::TestCase

  def test_should_render_dashboard_when_we_are_not_using_authentication
    Typus.stubs(:authentication).returns(:none)
    get :show
    assert_response :success
  end

end
