require "test_helper"

class Admin::<%= resource %>ControllerTest < ActionController::TestCase

  test "should render index" do
    get :index
    assert_template :index
  end

  test "should render new" do
    get :new
    assert_template :new
  end

end
