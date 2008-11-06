require File.dirname(__FILE__) + '/../test_helper'

class TypusControllerTest < ActionController::TestCase

  def setup
    Typus::Configuration.options[:recover_password] = true
    Typus::Configuration.options[:app_name] = "Typus Admin for the masses"
  end

  def test_should_render_login
    get :login
    assert_response :success
    assert_template 'login'
  end

  def test_should_redirect_to_login
    get :dashboard
    assert_response :redirect
    assert_redirected_to typus_login_url
  end

  def test_should_login_and_redirect_to_dashboard
    typus_user = typus_users(:admin)
    post :login, { :user => { :email => typus_user.email, 
                              :password => '12345678' } }
    assert_equal typus_user.id, @request.session[:typus]
    assert_response :redirect
    assert_redirected_to typus_dashboard_url
  end

  def test_should_not_login_disabled_user
    typus_user = typus_users(:disabled_user)
    post :login, { :user => { :email => typus_user.email, 
                              :password => '12345678' } }
    assert_nil @request.session[:typus]
    assert_response :redirect
    assert_redirected_to typus_login_url
  end

  def test_should_not_login_removed_role
    typus_user = typus_users(:removed_role)
    post :login, { :user => { :email => typus_user.email, 
                              :password => '12345678' } }
    assert_equal typus_user.id, @request.session[:typus]
    assert_response :redirect
    assert_redirected_to typus_dashboard_url
    get :dashboard
    assert_redirected_to typus_login_url
    assert_nil @request.session[:typus]
    assert flash[:error]
    assert_match /role doesn't exist on the system./, flash[:error]
  end

  def test_should_not_send_recovery_password_link_to_unexisting_user
    post :recover_password, { :user => { :email => 'unexisting' } }
    assert_response :redirect
    assert_redirected_to typus_recover_password_url
    assert !flash[:error]
    assert !flash[:notice]
    assert !flash[:success]
  end

  def test_should_send_recovery_password_link_to_existing_user
    admin = typus_users(:admin)
    post :recover_password, { :user => { :email => admin.email } }
    assert_response :redirect
    assert_redirected_to typus_login_url
    assert flash[:success]
    assert_match /Password recovery link sent to your email./, flash[:success]
  end

  def test_should_logout
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    get :logout
    assert_nil @request.session[:typus]
    assert_response :redirect
    assert_redirected_to typus_login_url
    assert !flash[:notice]
    assert !flash[:error]
    assert !flash[:warning]
  end

  def test_should_render_dashboard

    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id

    get :dashboard
    assert_response :success
    assert_template 'dashboard'
    assert_match /Typus Admin for the masses/, @response.body

  end

  def test_should_not_allow_recover_password_if_disabled

    get :recover_password

    assert_response :success
    assert_template 'recover_password'

    Typus::Configuration.options[:recover_password] = false
    get :recover_password

    assert_response :redirect
    assert_redirected_to typus_login_url

  end

  def test_should_not_allow_reset_password_if_disabled

    get :reset_password

    assert_response :success
    assert_template 'reset_password'

    Typus::Configuration.options[:recover_password] = false
    get :reset_password

    assert_response :redirect
    assert_redirected_to typus_login_url

  end

  def test_should_verify_typus_login_layout_does_not_include_recover_password_link

    get :login
    assert_match /Recover password/, @response.body

    Typus::Configuration.options[:recover_password] = false
    get :login
    assert !@response.body.include?("Recover password")

  end

  def test_should_verify_typus_login_layout_includes_version
    get :login
    assert_match /<!-- Typus #{Typus.version} -->/, @response.body
  end

  def test_should_verify_typus_layout_includes_version
    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id
    get :dashboard
    assert_match /<!-- Typus #{Typus.version} -->/, @response.body
  end

  def test_should_render_typus_login_top
    get :login
    assert_response :success
    assert_match /_top.html.erb/, @response.body
  end

  def test_should_render_typus_login_bottom
    get :login
    assert_response :success
    assert_match /_bottom.html.erb/, @response.body
  end

  def test_should_render_application_dashboard_sidebar

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :dashboard
    assert_response :success
    assert_match /_sidebar.html.erb/, @response.body

  end

  def test_should_render_application_dashboard_top

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :dashboard
    assert_response :success
    assert_match /_top.html.erb/, @response.body

  end

  def test_should_render_application_dashboard_bottom

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :dashboard
    assert_response :success
    assert_match /_bottom.html.erb/, @response.body

  end

  def test_should_verify_page_title_on_login
    get :login
    assert_match /<title>#{Typus::Configuration.options[:app_name]} &rsaquo; Login<\/title>/, @response.body
  end

  def test_should_verify_page_title_on_dashboard
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    get :dashboard
    assert_match /<title>#{Typus::Configuration.options[:app_name]} &rsaquo; Dashboard<\/title>/, @response.body
  end

  def test_should_create_first_typus_user
    TypusUser.destroy_all
    assert_nil @request.session[:typus]
    assert TypusUser.find(:all).empty?
    get :login
    assert_response :redirect
    assert_redirected_to :action => 'setup'
    post :setup, :user => { :email => 'example.com' }
    assert_response :redirect
    assert_redirected_to :action => 'setup'
    assert flash[:error]
    assert_equal "<strong>Yay!</strong> That doesn't seem like a valid email address.", flash[:error]
    post :setup, :user => { :email => 'john@example.com' }
    assert_response :redirect
    assert_redirected_to :action => 'dashboard'
    assert flash[:notice]
    assert_match /Your new password is/, flash[:notice]
    assert @request.session[:typus]
    assert !(TypusUser.find(:all).empty?)
    @request.session[:typus] = nil
    get :setup
    assert_redirected_to :action => 'login'
  end

end