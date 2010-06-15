require "test/test_helper"

class Admin::DashboardControllerTest < ActionController::TestCase

  should "render_dashboard_when_we_are_not_using_authentication" do
    Typus.stubs(:authentication).returns(:none)
    get :show
    assert_response :success
  end

end
