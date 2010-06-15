require "test/test_helper"

class Admin::DashboardControllerTest < ActionController::TestCase

  should "return_a_401_message" do
    Typus.stubs(:authentication).returns(:http_basic)
    get :show
    assert_response 401
  end

  should "render_show_when_user_authenticates_via_http_basic" do
    Typus.stubs(:authentication).returns(:http_basic)
    @request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("admin:columbia")
    get :show
    assert_response :success
  end

end
