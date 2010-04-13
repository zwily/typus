require "test/test_helper"
require "test/rails_app/app/controllers/admin/posts_controller"

class Admin::PostsControllerTest < ActionController::TestCase

  def setup
    @typus_user = typus_users(:admin)
    @request.session[:typus_user_id] = @typus_user.id
  end

end
