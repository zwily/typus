require "test/test_helper"

class Admin::CategoriesControllerTest < ActionController::TestCase

  def setup
    @typus_user = typus_users(:admin)
    @request.session[:typus_user_id] = @typus_user.id
  end

  def test_should_verify_form_partial_can_overwrited_by_model
    get :new
    assert_match "categories#_form.html.erb", @response.body
  end

end
