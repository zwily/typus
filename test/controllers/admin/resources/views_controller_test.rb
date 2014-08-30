require "test_helper"

=begin

  What's being tested here?

    - `set_context` which forces the display of items related to domain.

=end

class Admin::ViewsControllerTest < ActionController::TestCase

  setup do
    admin_sign_in

    @site = sites(:default)
    @site.update_column(:domain, 'test.host')

    View.create(ip: '127.0.0.1', site: @site)
    View.create(ip: '127.0.0.1')
  end

  test 'get index returns only views on the current_context' do
    get :index
    assert_response :success
    assert_equal [@site], assigns(:items).map(&:site)
  end

  test 'get new initializes item in the current_scope' do
    get :new
    assert_response :success
    assert_equal @site, assigns(:item).site
  end

end
