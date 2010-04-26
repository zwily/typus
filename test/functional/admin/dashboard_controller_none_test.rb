require "test/test_helper"

class Admin::DashboardControllerTest < ActionController::TestCase

  def test_should_render_dashboard_when_we_are_not_using_authentication
    Typus.stubs(:authentication).returns(:none)
    get :show
    assert_response :success
  end

  def test_show
    Typus.stubs(:authentication).returns(:basic)
    get :show
    assert_response 401
  end

  def test_should_render_show_when_user_authenticates_via_http_basic
    Typus.stubs(:authentication).returns(:basic)
    @request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("admin:columbia")
    get :show
    assert_response :success
  end

end
