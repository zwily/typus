require "test_helper"

=begin

  What's being tested here?

    - Scopes

  Hey! I do not recommend setting a default_scope because you'll probably get
  unexpected results. This is here for testing purposes, but please, avoid
  using this kind of stuff.

=end

class Admin::PagesControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id

    Factory(:page)
    Factory(:page, :status => false)
  end

  teardown do
    Page.delete_all
    TypusUser.delete_all
  end

  test "get :index returns scoped results" do
    get :index
    assert_equal Page.all, assigns(:items)
  end

end
