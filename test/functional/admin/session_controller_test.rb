require "test/test_helper"

class Admin::SessionControllerTest < ActionController::TestCase

  ##
  # :new
  ##

  def test_should_render_new
    Typus.expects(:admin_title).at_least_once.returns("Typus Test")

    get :new

    assert_response :success
    assert_select "title", "Typus Test - Session &rsaquo; New"
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
    Typus.expects(:mailer_sender).returns("john@example.com")

    get :new

    assert @response.body.include?("Recover password")
  end

  ##
  # :create
  ##

  def test_should_not_create_session_for_invalid_users
    post :create, { :typus_user => { :email => "john@example.com", :password => "XXXXXXXX" } }

    assert_response :redirect
    assert_redirected_to new_admin_session_path
    assert_equal "The email and/or password you entered is invalid.", flash[:alert]
  end

  def test_should_not_create_session_for_a_disabled_user
    typus_user = typus_users(:disabled_user)

    post :create, { :typus_user => { :email => typus_user.email, :password => "12345678" } }

    assert_nil @request.session[:typus_user_id]
    assert_response :redirect
    assert_redirected_to new_admin_session_path
  end

  def test_should_create_session_for_an_enabled_user
    typus_user = typus_users(:admin)

    post :create, { :typus_user => { :email => typus_user.email, :password => "12345678" } }

    assert_equal typus_user.id, @request.session[:typus_user_id]
    assert_response :redirect
    assert_redirected_to admin_dashboard_path
  end

  ##
  # :destroy
  ##

  def test_should_destroy
    @request.session[:typus_user_id] = typus_users(:admin).id

    delete :destroy

    assert_nil @request.session[:typus_user_id]
    assert_response :redirect
    assert_redirected_to new_admin_session_path
    assert flash.empty?
  end

end
