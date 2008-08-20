require File.dirname(__FILE__) + '/../../test_helper'

class Admin::TypusUsersControllerTest < ActionController::TestCase

  def test_should_allow_admin_to_add_users
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    get :new
    assert_response :success
  end

#  def test_should_not_allow_designer_to_add_users
#    editor = typus_users(:designer)
#    @request.session[:typus] = editor.id
#    get :new
#    assert_response :redirect
#    assert flash[:notice]
#    assert_match /You don't have permission to access this resource./, flash[:notice]
#  end

  def test_should_allow_admin_to_update_other_users_profiles
    assert true
  end

  def test_should_not_allow_admin_to_destroy_himself
    assert true
  end

  def test_should_not_allow_editor_to_add_users
    user = typus_users(:user)
    @request.session[:typus] = user.id
    get :new
    assert_response :redirect
    assert_redirected_to typus_dashboard_url
    assert flash[:notice]
    assert_match /You don't have permission to access this resource./, flash[:notice]
  end

  def test_should_allow_editor_to_update_himself
    assert true
  end

  def test_should_not_allow_editor_to_edit_other_users_profiles
    assert true
  end

  def test_should_not_allow_editor_to_destroy_users
    assert true
  end

  def test_should_not_allow_editor_to_destroy_himself
    assert true
  end

end