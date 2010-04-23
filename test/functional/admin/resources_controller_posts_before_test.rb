require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  def setup
    @typus_user = typus_users(:admin)
    @request.session[:typus_user_id] = @typus_user.id
  end

  def test_should_verify_we_are_root
    assert @typus_user.is_root?
  end

end
