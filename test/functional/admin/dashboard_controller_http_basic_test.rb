require "test/test_helper"

class Admin::DashboardControllerTest < ActionController::TestCase

  def test_should_return_a_401_message
    Typus.stubs(:authentication).returns(:http_basic)
    get :show
    assert_response 401
  end

  def test_should_render_show_when_user_authenticates_via_http_basic
    Typus.stubs(:authentication).returns(:http_basic)
    @request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("admin:columbia")
    get :show
    assert_response :success
  end

end
