require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test the template extensions rendering and all the 
# things related to views.
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

  def test_should_verify_page_title_on_index
    get :index
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} &rsaquo; Comments"
  end

  def test_should_verify_page_title_on_new
    get :new
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} &rsaquo; Comments &rsaquo; New"
  end

  def test_should_verify_page_title_on_edit
    comment = comments(:first)
    get :edit, :id => comment.id
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} &rsaquo; Comments &rsaquo; Edit"
  end

  def test_should_show_add_new_link_in_index
    get :index
    assert_response :success
    assert_match "Add comment", @response.body
  end

  def test_should_show_trash_record_image_and_link_in_index
    get :index
    assert_response :success
    assert_match /trash.gif/, @response.body
  end

  def test_should_not_show_remove_record_link_in_index

    typus_user = typus_users(:designer)
    @request.session[:typus] = typus_user.id

    get :index
    assert_response :success
    assert_no_match /trash.gif/, @response.body

  end

end