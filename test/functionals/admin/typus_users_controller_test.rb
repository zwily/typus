require File.dirname(__FILE__) + '/../../test_helper'

class Admin::TypusUsersControllerTest < ActionController::TestCase

  def test_should_allow_admin_add_users
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    get :new
    assert_response :success
  end

end