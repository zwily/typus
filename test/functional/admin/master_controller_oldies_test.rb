require 'test/helper'

class Admin::CategoriesControllerTest < ActionController::TestCase

  def setup
    @request.session[:typus_user_id] = user.id
  end

  def test_should_verify_items_are_sorted_by_position_on_list
    get :index
    assert_response :success
    assert_equal [ 1, 2, 3 ], assigns['items'].items.map(&:position)
    assert_equal [ 2, 3, 1 ], Category.find(:all, :order => "id ASC").map(&:position)
  end

end

class Admin::PostsControllerTest < ActionController::TestCase

=begin

  # FIXME

  def test_should_check_redirection_when_theres_no_http_referer_on_new

    typus_user = typus_users(:designer)
    @request.session[:typus_user_id] = typus_user.id

    get :new
    assert_response :redirect
    assert_redirected_to admin_dashboard_path

    assert_equal "Designer can't perform action. (new)", flash[:notice]

    @request.env['HTTP_REFERER'] = '/admin/posts'

    typus_user = typus_users(:designer)
    @request.session[:typus_user_id] = typus_user.id

    get :new
    assert_response :redirect
    assert_redirected_to '/admin/posts'

    assert_equal "Designer can't perform action. (new)", flash[:notice]

  end

=end

end