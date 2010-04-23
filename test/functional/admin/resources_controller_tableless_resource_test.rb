require "test/test_helper"

class Admin::StatusControllerTest < ActionController::TestCase

  def setup
    @request.session[:typus_user_id] = typus_users(:admin).id
  end

  def test_should_verify_admin_can_go_to_index
    get :index
    assert_response :success
    assert_template 'index'
  end

  def test_should_verify_editor_cannot_go_to_index
    @request.session[:typus_user_id] = typus_users(:editor).id
    get :index
    assert_response :unprocessable_entity
  end

  def test_should_verify_status_is_not_available_if_user_not_logged
    @request.session[:typus_user_id] = nil
    get :index
    assert_response :redirect
    assert_redirected_to new_admin_session_path(:back_to => '/admin/status')
  end

  def test_should_verify_admin_cannot_go_to_show
    get :show
    assert_response :unprocessable_entity
  end

end
