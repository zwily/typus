require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test resources which are not related to a model.
#
class Admin::StatusControllerTest < ActionController::TestCase

  def setup
    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id
  end

  def test_should_verify_admin_can_go_to_index
    get :index
    assert_response :success
    assert_template 'index'
  end

  def test_should_verify_admin_can_not_go_to_show
    get :show
    assert_response :redirect
    assert_redirected_to typus_dashboard_url
  end

end