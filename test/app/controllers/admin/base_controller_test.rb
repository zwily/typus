require "test_helper"

=begin

  What's being tested here?

    - Access to user_guide.

=end

class Admin::BaseControllerTest < ActionController::TestCase

  test "user_guide is not displayed when user is not logged in" do
    get :user_guide
    assert_response :redirect
    assert_redirected_to new_admin_session_path
  end

  test "user_guide is displayed when user is logged in" do
    admin_sign_in
    get :user_guide
    assert_response :success
  end

end
