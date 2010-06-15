require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  setup do
    @typus_user = typus_users(:admin)
    @request.session[:typus_user_id] = @typus_user.id
  end

end
