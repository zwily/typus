require "test_helper"

=begin

  What's being tested here?

    - Resource controller (which is not associated with a model).

=end

class Admin::StatusControllerTest < ActionController::TestCase

  test "admin has access" do
    admin_sign_in
    get :index
    assert_response :success
    assert_template 'index'
  end

  test "editor should not have access" do
    editor_sign_in
    get :index
    assert_response :unprocessable_entity
  end

  test "not logged in user is redirected to new_admin_session_path" do
    reset_session
    get :index
    assert_response :redirect
    assert_redirected_to new_admin_session_path # (:back_to => '/admin/status')
  end

end
