require "test_helper"

=begin

  What's being tested here?

    - `set_context` which forces the display of items related to domain.

=end

class Admin::ViewsControllerTest < ActionController::TestCase

  setup do
    @request.session[:typus_user_id] = Factory(:typus_user).id
    @site = Factory(:site, :domain => 'test.host')
    Factory(:view, :site => @site)
    Factory(:view)
  end

  teardown do
    reset_session
  end

  should_eventually "get :index returns only views on the current_context" do
    get :index
    assert_response :success
    assert_equal [@site], assigns(:items)
  end

  test "get :new should initialize item in the current_scope" do
    get :new
    assert_response :success
    assert assigns(:item).site.eql?(@site)
  end

end
