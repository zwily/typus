require "test/test_helper"

class Admin::CategoriesControllerTest < ActionController::TestCase

  setup do
    @typus_user = typus_users(:admin)
    @request.session[:typus_user_id] = @typus_user.id
  end

  should "verify form partial can overwrited by model" do
    get :new
    assert_match "categories#_form.html.erb", @response.body
  end

end
