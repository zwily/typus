require "test/test_helper"

class Admin::AccountControllerTest < ActionController::TestCase

  ##
  # :new
  ##

  def test_should_verify_new_redirect_to_new_admin_session_when_there_are_admin_users
    get :new
    assert_response :redirect
    assert_redirected_to new_admin_session_path
  end

  def test_should_verify_new_is_rendered_when_there_are_not_admin_users
    TypusUser.expects(:count).at_least_once.returns(0)

    get :new

    assert_response :success
    assert_template "new"
    assert_match "layouts/admin/account", @controller.inspect
    assert_equal "Enter your email below to create the first user.", flash[:notice]
  end

  ##
  # :forgot_password
  ##

  def test_should_verify_forgot_password_redirects_to_new_when_there_are_no_admin_users
    TypusUser.expects(:count).at_least_once.returns(0)

    get :forgot_password

    assert_response :redirect
    assert_redirected_to new_admin_account_path
  end

  def test_should_verify_forgot_password_is_rendered_when_there_are_admin_users
    get :forgot_password

    assert_response :success
    assert_template "forgot_password"
  end

  def test_should_not_send_recovery_password_link_to_unexisting_user
    post :forgot_password, { :typus_user => { :email => "unexisting" } }

    assert_response :success
    assert flash.empty?
  end

  def test_should_send_recovery_password_link_to_existing_user
    admin = typus_users(:admin)

    post :forgot_password, { :typus_user => { :email => admin.email } }

    assert_response :redirect
    assert_redirected_to new_admin_session_path
    assert_equal "Password recovery link sent to your email.", flash[:notice]
  end

  ##
  # :show
  ##

  def test_should_create_admin_user_session_and_redirect_user_to_its_details
    typus_user = typus_users(:admin)
    get :show, { :id => typus_user.token }

    assert_equal typus_user.id, @request.session[:typus_user_id]
    assert_response :redirect
    assert_redirected_to :controller => "admin/typus_users", :action => "edit", :id => typus_user.id
  end

  def test_should_return_404_on_reset_passsword_if_token_is_not_valid
    assert_raise(ActiveRecord::RecordNotFound) { get :show, { :id => "unexisting" } }
  end

  ##
  # :create
  ##

  def test_should_should_not_sign_up_invalid_email
    TypusUser.expects(:count).at_least_once.returns(0)

    post :create, :typus_user => { :email => "example.com" }

    assert_response :redirect
    assert_redirected_to :action => :new
    assert flash.empty?
  end

  def test_should_sign_up_valid_email
    TypusUser.destroy_all

    assert_difference "TypusUser.count" do
      post :create, :typus_user => { :email => "john@example.com" }
    end
    assert_response :redirect
    assert_redirected_to admin_dashboard_path
    assert_equal %(Password set to 'columbia'.), flash[:notice]
    assert @request.session[:typus_user_id]
  end

end
