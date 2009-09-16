require 'test/helper'

class Admin::CommentsControllerTest < ActionController::TestCase

  def setup
    @typus_user = typus_users(:admin)
    @request.session[:typus_user_id] = @typus_user.id
    @comment = comments(:first)
  end

  ##
  # get :index
  ##

  def test_should_render_index_and_verify_presence_of_custom_partials
    get :index
    partials = %w( _index.html.erb _sidebar.html.erb )
    partials.each { |p| assert_match p, @response.body }
  end

  def test_should_render_index_and_verify_page_title
    get :index
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} - Comments"
  end

  def test_should_render_index_and_show_add_entry_link
    get :index
    assert_response :success
    assert_match 'Add entry', @response.body
  end

  def test_should_render_index_and_not_show_add_entry_link

    typus_user = typus_users(:designer)
    @request.session[:typus_user_id] = typus_user.id

    get :index
    assert_response :success
    assert_no_match /Add entry/, @response.body

  end

  # OPTIMIZE: We can do it by <div id="...">Trash</div>
  def test_should_render_index_and_show_trash_item_image
    get :index
    assert_response :success
    assert_match "Trash", @response.body
  end

  def test_should_render_index_and_not_show_trash_image

    typus_user = typus_users(:designer)
    @request.session[:typus_user_id] = typus_user.id

    get :index
    assert_response :success
    assert_no_match /Trash/, @response.body

  end

  ##
  # get :new
  ##

  def test_should_render_comments_partials_on_new
    get :new
    partials = %w( _new.html.erb _sidebar.html.erb )
    partials.each { |p| assert_match p, @response.body }
  end

  def test_should_render_new_and_verify_page_title
    get :new
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} - Comments &rsaquo; New"
  end

  ##
  # get :edit
  ##

  def test_should_render_edit_and_verify_presence_of_custom_partials
    get :edit, { :id => @comment.id }
    partials = %w( _edit.html.erb _sidebar.html.erb )
    partials.each { |p| assert_match p, @response.body }
  end

  def test_should_render_edit_and_verify_page_title
    get :edit, { :id => @comment.id }
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} - Comments &rsaquo; Edit"
  end

  ##
  # get :show
  ##

  def test_should_render_show_and_verify_presence_of_custom_partials
    get :show, { :id => @comment.id }
    partials = %w( _show.html.erb _sidebar.html.erb )
    partials.each { |p| assert_match p, @response.body }
  end

  def test_should_render_show_and_verify_page_title
    get :show, { :id => @comment.id }
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} - Comments &rsaquo; Show"
  end

=begin

  # FIXME

  def test_should_verify_new_comment_contains_a_link_to_add_a_new_post
    get :new
    match = '/admin/posts/new?back_to=%2Fadmin%2Fcomments%2Fnew&amp;selected=post_id'
    assert_match match, @response.body
  end

  def test_should_verify_edit_comment_contains_a_link_to_add_a_new_post
    comment = comments(:first)
    get :edit, { :id => comment.id }
    match = "/admin/posts/new?back_to=%2Fadmin%2Fcomments%2Fedit%2F#{comment.id}&amp;selected=post_id"
    assert_match match, @response.body
  end

=end

end