require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test the template extensions rendering
#
class Admin::CommentsControllerTest < ActionController::TestCase

  def setup
    @typus_user = typus_users(:admin)
    @request.session[:typus] = @typus_user.id
    @comment = comments(:first)
  end

  def test_should_render_posts_sidebar_on_index_edit_and_show

    get :index
    assert_response :success
    assert_match /_index_sidebar.html.erb/, @response.body

    get :edit, { :id => @comment.id }
    assert_response :success
    assert_match /_edit_sidebar.html.erb/, @response.body

    get :show, { :id => @comment.id }
    assert_response :success
    assert_match /_show_sidebar.html.erb/, @response.body

  end

  def test_should_render_posts_top_on_index_show_and_edit

    get :index
    assert_response :success
    assert_match /_index_top.html.erb/, @response.body

    get :edit, { :id => @comment.id }
    assert_response :success
    assert_match /_edit_top.html.erb/, @response.body

    get :show, { :id => @comment.id }
    assert_response :success
    assert_match /_show_top.html.erb/, @response.body

  end

  def test_should_render_posts_bottom_on_index_show_and_edit

    get :index
    assert_response :success
    assert_match /_index_bottom.html.erb/, @response.body

    get :edit, { :id => @comment.id }
    assert_response :success
    assert_match /_edit_bottom.html.erb/, @response.body

    get :show, { :id => @comment.id }
    assert_response :success
    assert_match /_show_bottom.html.erb/, @response.body

  end

end