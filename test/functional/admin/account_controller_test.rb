require "test/test_helper"

class Admin::AccountControllerTest < ActionController::TestCase

  ##
  # get :sign_in
  ##

  def test_should_sign_in
    get :sign_in
    assert_response :success
    assert_template "sign_in"
  end

  def test_should_sign_in_with_post_and_redirect_to_dashboard
    typus_user = typus_users(:admin)
    post :sign_in, { :typus_user => { :email => typus_user.email, :password => "12345678" } }
    assert_equal typus_user.id, @request.session[:typus_user_id]
    assert_response :redirect
    assert_redirected_to admin_dashboard_path
  end

  def test_should_sign_in_with_post_and_redirect_to_sign_in_with_an_error
    post :sign_in, { :typus_user => { :email => "john@example.com", :password => "XXXXXXXX" } }
    assert_response :redirect
    assert_redirected_to admin_sign_in_path
    assert_equal "The email and/or password you entered is invalid.", flash[:alert]
  end

  def test_should_not_sign_in_a_disabled_user
    typus_user = typus_users(:disabled_user)
    post :sign_in, { :typus_user => { :email => typus_user.email, :password => "12345678" } }
    assert_nil @request.session[:typus_user_id]
    assert_response :redirect
    assert_redirected_to admin_sign_in_path
  end

  def test_should_not_send_recovery_password_link_to_unexisting_user

    Typus.expects(:email).returns("john@example.com")

    post :recover_password, { :typus_user => { :email => "unexisting" } }
    assert_response :redirect
    assert_redirected_to admin_recover_password_path
    [ :notice, :error, :warning ].each { |f| assert !flash[f] }

  end

  def test_should_send_recovery_password_link_to_existing_user

    Typus.expects(:email).returns("john@example.com")

    admin = typus_users(:admin)
    post :recover_password, { :typus_user => { :email => admin.email } }

    assert_response :redirect
    assert_redirected_to admin_sign_in_path
    assert_equal "Password recovery link sent to your email.", flash[:notice]

  end

  def test_should_sign_out
    admin = typus_users(:admin)
    @request.session[:typus_user_id] = admin.id
    get :sign_out
    assert_nil @request.session[:typus_user_id]
    assert_response :redirect
    assert_redirected_to admin_sign_in_path
    [ :notice, :error, :warning ].each { |f| assert !flash[f] }
  end

  ##
  # reset_password
  ##

  def test_should_not_reset_password

    get :reset_password
    assert_response :redirect
    assert_redirected_to admin_sign_in_path

  end

  def test_should_reset_password_when_recover_password_is_true

    Typus.expects(:email).returns("john@example.com")

    typus_user = typus_users(:admin)
    get :reset_password, { :token => typus_user.token }

    assert_response :success
    assert_template "reset_password"

  end

  def test_should_redirect_to_sign_in_user_after_reset_password

    Typus.expects(:email).returns("john@example.com")

    typus_user = typus_users(:admin)
    post :reset_password, { :token => typus_user.token, :typus_user => { :password => "12345678", :password_confirmation => "12345678" } }

    assert_response :redirect
    assert_redirected_to admin_dashboard_path

  end

  def test_should_be_redirected_if_password_does_not_match_confirmation

    Typus.expects(:email).returns("john@example.com")

    typus_user = typus_users(:admin)
    post :reset_password, { :token => typus_user.token, :typus_user => { :password => "drowssap", :password_confirmation => "drowssap2" } }
    assert_response :success

  end

  def test_should_only_be_allowed_to_reset_password

    Typus.expects(:email).returns("john@example.com")

    typus_user = typus_users(:admin)
    post :reset_password, { :token => typus_user.token, :typus_user => { :password => "drowssap", :password_confirmation => "drowssap", :role => "superadmin" } }
    typus_user.reload
    assert_not_equal typus_user.role, "superadmin"

  end

  def test_should_return_404_on_reset_passsword_if_token_is_not_valid

    Typus.expects(:email).returns("john@example.com")

    assert_raise(ActiveRecord::RecordNotFound) { get :reset_password, { :token => "INVALID" } }

  end

  def test_should_reset_password_with_valid_token

    Typus.expects(:email).returns("john@example.com")

    typus_user = typus_users(:admin)
    get :reset_password, { :token => typus_user.token }
    assert_response :success
    assert_template "reset_password"

  end

  ##
  # sign_up
  ##

  def test_should_verify_sign_up_works

    TypusUser.destroy_all
    assert TypusUser.all.empty?

    get :sign_up

    assert_response :success
    assert_template "sign_up"
    assert_match "layouts/admin/account", @controller.inspect
    assert_equal "Enter your email below to create the first user.", flash[:notice]

  end

  def test_should_should_not_sign_up_invalid_email

    TypusUser.destroy_all

    post :sign_up, :typus_user => { :email => "example.com" }

    assert_response :success
    assert_equal "That doesn't seem like a valid email address.", flash[:alert]

  end

  def test_should_sign_up_valid_email

    TypusUser.destroy_all

    assert_difference "TypusUser.count" do
      post :sign_up, :typus_user => { :email => "john@example.com" }
    end

    assert_response :redirect
    assert_redirected_to admin_dashboard_path
    assert_equal %(Password set to 'columbia'.), flash[:notice]
    assert @request.session[:typus_user_id]

  end

  ##
  # sign_in
  ##

  def test_should_render_sign_in

    Typus.expects(:admin_title).at_least_once.returns("Typus Test")

    get :sign_in
    assert_response :success

    assert_select "title", "Typus Test - Account &rsaquo; Sign in"
    assert_select "h1", "Typus Test"
    assert_match "layouts/admin/account", @controller.inspect

  end

  def test_should_redirect_to_sign_up_when_no_typus_users
    TypusUser.destroy_all
    get :sign_in
    assert_response :redirect
    assert_redirected_to admin_sign_up_path
  end

  def test_should_verify_typus_sign_in_layout_does_not_include_recover_password_link
    get :sign_in
    assert !@response.body.include?("Recover password")
  end

  def test_should_verify_typus_sign_in_layout_includes_recover_password_link
    Typus.expects(:email).returns("john@example.com")
    get :sign_in
    assert @response.body.include?("Recover password")
  end

  ##
  # sign_out
  ##

  def test_should_verify_sign_out
    @request.session[:typus_user_id] = typus_users(:admin).id
    get :sign_out
    assert_nil @request.session[:typus_user_id]
    assert_redirected_to admin_sign_in_path
  end

end
