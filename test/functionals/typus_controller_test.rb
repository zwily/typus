require File.dirname(__FILE__) + '/../test_helper'

class TypusControllerTest < ActionController::TestCase

  def setup
    @controller = TypusController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
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
    post :login, { :user => { :email => 'admin@typus.org', 
                              :password => '12345678' } }
    assert_equal @request.session[:typus], 1
    assert_response :redirect
    assert_redirected_to typus_dashboard_url
  end

  def test_should_not_login_disable_user
    post :login, { :user => { :email => 'disabled_user@typus.org', 
                              :password => '12345678' } }
    assert_equal @request.session[:typus], nil
    assert_response :redirect
    assert_redirected_to typus_login_url
  end

  def test_should_logout
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    get :logout
    assert_equal @request.session[:typus], nil
    assert_response :redirect
    assert_redirected_to typus_login_url
  end

  def test_should_render_dashboard

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    Typus::Configuration.options[:app_name] = "Typus Admin for the masses"

    get :dashboard
    assert_response :success
    assert_template 'dashboard'
    assert_match /Typus Admin for the masses/, @response.body

  end

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

end