require "test_helper"

class Admin::CategoriesControllerTest < ActionController::TestCase

  setup do
    @request.session[:typus_user_id] = Factory(:typus_user).id
    @request.env['HTTP_REFERER'] = '/admin/categories'
  end

  should "verify form partial can overwrited by model" do
    get :new
    assert_match "categories#_form.html.erb", @response.body
  end

end
