require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test the CRUD actions and template extensions rendering
#
class Admin::CommentsControllerTest < ActionController::TestCase

  def setup
    @typus_user = typus_users(:admin)
    @request.session[:typus] = @typus_user.id
  end

  def test_should_verify_admin_can_go_to_index
    get :index
    assert_response :success
    assert_template 'index'
  end

end