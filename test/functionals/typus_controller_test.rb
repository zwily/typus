require File.dirname(__FILE__) + '/../test_helper'

class TypusControllerTest < ActionController::TestCase

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

end