require File.dirname(__FILE__) + '/../test_helper'

class AdminControllerTest < ActionController::TestCase

#  def test_should_redirect_to_login
#    get :index
#    assert_response :redirect
#    assert_redirected_to typus_login_url
#  end

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

  def test_should_render_index
    post :login, { :user => { :email => 'admin@typus.org', 
                              :password => '12345678' } }
    assert_equal @request.session[:typus], 1
    get :index, { :model => 'posts' }
    assert_response :success
    assert_template 'index'
  end

  def test_should_not_render_index_for_undefined_model
    @request.session[:typus] = 1
    get :index, { :model => 'unexisting' }
    assert_response :redirect
    assert_redirected_to :action => 'dashboard'
  end

  def test_should_logout
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    get :logout
    assert_equal @request.session[:typus], nil
    assert_response :redirect
    assert_redirected_to typus_login_url
  end

  def test_should_perform_a_search
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    get :index, { :model => 'posts', :search => 'neinonon' }
    assert_response :success
    assert_template 'index'
  end

  def test_should_allow_admin_add_users
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    get :new, { :model => 'typus_users' }
    assert_response :success
  end

end