require "test/test_helper"

class Admin::SessionControllerTest < ActionController::TestCase

  def test_should_render_new

    Typus.expects(:admin_title).at_least_once.returns("Typus Test")

    get :new
    assert_response :success

    assert_select "title", "Typus Test - Account &rsaquo; Sign in"
    assert_select "h1", "Typus Test"
    assert_match "layouts/admin/account", @controller.inspect

  end

  def test_should_redirect_to_new_admin_account_when_no_admin_users
    TypusUser.expects(:count).at_least_once.returns(0)
    get :new
    assert_response :redirect
    assert_redirected_to new_admin_account_path
  end

  def test_should_verify_typus_sign_in_layout_does_not_include_recover_password_link
    get :new
    assert !@response.body.include?("Recover password")
  end

  def test_should_verify_typus_sign_in_layout_includes_recover_password_link
    Typus.expects(:email).returns("john@example.com")
    get :new
    assert @response.body.include?("Recover password")
  end

  def test_should_destroy
    @request.session[:typus_user_id] = typus_users(:admin).id
    delete :destroy
    assert_nil @request.session[:typus_user_id]
    assert_response :redirect
    assert_redirected_to new_admin_session_path
    [:alert, :notice].each { |f| assert !flash[f] }
  end

end
