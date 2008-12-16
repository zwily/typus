require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test the CRUD actions, template extensions rendering and
#
#   - Relate comment which is a has_many relationship.
#   - Unrelate comment which is a has_many relationship.
#
class Admin::PostsControllerTest < ActionController::TestCase

  def setup
    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id
  end

  def test_should_redirect_to_login

    @request.session[:typus] = nil

    get :index
    assert_response :redirect
    assert_redirected_to typus_login_url(:back_to => '/admin/posts')
    get :edit, { :id => 1 }
    assert_response :redirect
    assert_redirected_to typus_login_url(:back_to => '/admin/posts')

  end

  def test_should_render_index
    get :index
    assert_response :success
    assert_template 'index'
  end

  def test_should_render_new
    test_should_update_item_and_redirect_to_index
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_should_create_item_and_redirect_to_index
    Typus::Configuration.options[:edit_after_create] = false
    assert_difference 'Post.count' do
      post :create, { :item => { :title => "This is another title", :body => "Body" } }
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end
  end

  def test_should_create_item_and_redirect_to_edit
    Typus::Configuration.options[:edit_after_create] = true
    assert_difference 'Post.count' do
      post :create, { :item => { :title => "This is another title", :body => "Body" } }
      assert_response :redirect
      assert_redirected_to :action => 'edit'
    end
  end

  def test_should_render_show
    post_ = posts(:published)
    get :show, { :id => post_.id }
    assert_response :success
    assert_template 'show'
  end

  def test_should_render_edit
    post_ = posts(:published)
    get :edit, { :id => post_.id }
    assert_response :success
    assert_template 'edit'
  end

  def test_should_update_item_and_redirect_to_index
    Typus::Configuration.options[:edit_after_create] = false
    post_ = posts(:published)
    post :update, { :id => post_.id, :title => "Updated" }
    assert_response :redirect
    assert_redirected_to :action => 'index'
  end

  def test_should_update_item_and_redirect_to_edit
    Typus::Configuration.options[:edit_after_create] = true
    post_ = posts(:published)
    post :update, { :id => post_.id, :title => "Updated" }
    assert_response :redirect
    assert_redirected_to :action => 'edit', :id => post_.id
  end

  def test_should_allow_admin_to_toggle_item
    @request.env["HTTP_REFERER"] = "/admin/posts"
    post = posts(:unpublished)
    get :toggle, { :id => post.id, :field => 'status' }
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert flash[:success]
    assert Post.find(post.id).status
  end

  def test_should_perform_a_search
    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id
    get :index, { :search => 'neinonon' }
    assert_response :success
    assert_template 'index'
  end

  def test_should_relate_a_tag_to_a_post_and_then_unrelate
    tag = tags(:first)
    post_ = posts(:published)
    @request.env["HTTP_REFERER"] = "/admin/posts/#{post_.id}/edit"
    post :relate, { :id => post_.id, :related => { :model => "Tag", :id => tag.id } }
    assert_response :redirect
    assert flash[:success]
    assert_redirected_to :action => 'edit', :id => post_.id
    post :unrelate, { :id => post_.id, :model => "Tag", :model_id => tag.id }
    assert_response :redirect
    assert flash[:success]
  end

  def test_should_check_redirection_when_theres_no_http_referer_on_new

    typus_user = typus_users(:designer)
    @request.session[:typus] = typus_user.id

    get :new
    assert_response :redirect
    assert_redirected_to typus_dashboard_url

    assert flash[:notice]
    assert_equal "Designer can't perform action. (new)", flash[:notice]

    @request.env["HTTP_REFERER"] = "/admin/posts"

    typus_user = typus_users(:designer)
    @request.session[:typus] = typus_user.id

    get :new
    assert_response :redirect
    assert_redirected_to "/admin/posts"

    assert flash[:notice]
    assert_equal "Designer can't perform action. (new)", flash[:notice]

  end

  def test_should_show_add_new_link_in_index

    get :index
    assert_response :success
    assert_match "Add post", @response.body

  end

  def test_should_not_show_add_new_link_in_index

    typus_user = typus_users(:designer)
    @request.session[:typus] = typus_user.id

    get :index
    assert_response :success
    assert_no_match /Add post/, @response.body

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

  def test_should_disable_toggle_and_check_links_are_disabled
    Typus::Configuration.options[:toggle] = false
    @request.env["HTTP_REFERER"] = "/admin/posts"
    post = posts(:unpublished)
    get :toggle, { :id => post.id, :field => 'status' }
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert !flash[:success]
    assert flash[:warning]
    assert_match /Toggle is disabled/, flash[:warning]
    Typus::Configuration.options[:toggle] = true
  end

  def test_should_verify_page_title_on_index
    get :index
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} &rsaquo; Posts"
  end

  def test_should_verify_page_title_on_new
    get :new
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} &rsaquo; Posts &rsaquo; New"
  end

  def test_should_verify_page_title_on_edit
    post_ = posts(:published)
    get :edit, :id => post_.id
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} &rsaquo; Posts &rsaquo; Edit"
  end

  def test_should_verify_new_and_edit_page_contains_a_link_to_add_a_new_user

    get :new
    match = "/admin/users/new?back_to=%2Fadmin%2Fposts%2Fnew&amp;selected=user_id"
    assert_match match, @response.body

    post_ = posts(:published)
    get :edit, :id => post_.id
    match = "/admin/users/new?back_to=%2Fadmin%2Fposts%2F1%2Fedit&amp;selected=user_id"
    assert_match match, @response.body

  end

end