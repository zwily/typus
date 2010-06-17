require "test/test_helper"

class Admin::SessionControllerTest < ActionController::TestCase

  context "Setup" do

=begin
    # FIXME: 20100617
    should "redirect_to_new_admin_account_when_no_admin_users" do
      get :new
      assert_response :redirect
      assert_redirected_to new_admin_account_path
    end
=end

    should "verify_typus_sign_in_layout_does_not_include_recover_password_link" do
      get :new
      assert !@response.body.include?("Recover password")
    end

=begin
    # FIXME: 20100617
    should "verify_typus_sign_in_layout_includes_recover_password_link" do
      Typus.expects(:mailer_sender).returns("john@example.com")
      get :new
      assert @response.body.include?("Recover password")
    end
=end

  end

  context "With users" do

    setup do
      @typus_user = Factory(:typus_user)
    end

    should "render new" do
      Typus.expects(:admin_title).at_least_once.returns("Typus Test")

      get :new

      assert_response :success
      assert_select "title", "Sign in"
      assert_select "h1", "Typus Test"
      assert_match "layouts/admin/account", @controller.inspect
    end

    should "not_create_session_for_invalid_users" do
      post :create, { :typus_user => { :email => "john@example.com", :password => "XXXXXXXX" } }

      assert_response :redirect
      assert_redirected_to new_admin_session_path
      assert_equal "The email and/or password you entered is invalid.", flash[:alert]
    end

    should "not_create_session_for_a_disabled_user" do
      typus_user = Factory(:typus_user, :email => "disabled@example.com", :status => false)

      post :create, { :typus_user => { :email => typus_user.email, :password => "12345678" } }

      assert @request.session[:typus_user_id].nil?
      assert_response :redirect
      assert_redirected_to new_admin_session_path
    end

    should "create_session_for_an_enabled_user" do
      post :create, { :typus_user => { :email => @typus_user.email, :password => "12345678" } }

      assert_equal @typus_user.id, @request.session[:typus_user_id]
      assert_response :redirect
      assert_redirected_to admin_dashboard_path
    end

    should "destroy" do
      delete :destroy

      assert @request.session[:typus_user_id].nil?
      assert_response :redirect
      assert_redirected_to new_admin_session_path
      assert flash.empty?
    end

  end

end
