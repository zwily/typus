require File.dirname(__FILE__) + '/../test_helper'

class TypusControllerTest < ActionController::TestCase

  def setup
    Typus::Configuration.options[:recover_password] = true
  end

  def test_should_render_login

    Typus::Configuration.options[:app_name] = "Typus Admin for the masses"

    get :login
    assert_response :success
    assert_template 'login'
    assert_match /Typus Admin for the masses/, @response.body

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
    assert_equal @request.session[:typus], typus_user.id
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

    Typus::Configuration.options[:app_name] = "Typus Admin for the masses"

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

=begin

  def test_should_render_application_dashboard_sidebar

    file = "#{RAILS_ROOT}/app/views/typus/_dashboard_sidebar.html.erb"
    open(file, 'w') { |f| f << "Dashboard Sidebar" }
    assert File.exists? file

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :dashboard
    assert_response :success
    assert_match /Dashboard Sidebar/, @response.body

  end

=end

=begin

  def test_should_render_application_dashboard_top

    file = "#{RAILS_ROOT}/app/views/typus/_dashboard_top.html.erb"
    open(file, 'w') { |f| f << "Dashboard Top" }
    assert File.exists? file

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :dashboard
    assert_response :success
    assert_match /Dashboard Top/, @response.body

  end

=end

=begin

  def test_should_render_application_dashboard_bottom

    file = "#{RAILS_ROOT}/app/views/typus/_dashboard_bottom.html.erb"
    open(file, 'w') { |f| f << "Dashboard Bottom" }
    assert File.exists? file

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :dashboard
    assert_response :success
    assert_match /Dashboard Bottom/, @response.body

  end

=end

end