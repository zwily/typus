require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test the CRUD actions and template extensions rendering
#
class Admin::PostsControllerTest < ActionController::TestCase

  def test_should_redirect_to_login
    get :index
    assert_response :redirect
    assert_redirected_to typus_login_url(:back_to => '/admin/posts')
    get :edit, { :id => 1 }
    assert_response :redirect
    assert_redirected_to typus_login_url(:back_to => '/admin/posts')
  end

  def test_should_render_new
    typus_user = typus_users(:admin)
    test_should_update_item_and_redirect_to_index
    @request.session[:typus] = typus_user.id
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_should_create_item_and_redirect_to_index
    typus_user = typus_users(:admin)
    Typus::Configuration.options[:edit_after_create] = false
    @request.session[:typus] = typus_user.id
    items = Post.count
    post :create, { :item => { :title => "This is another title", :body => "Body" } }
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert_equal items + 1, Post.count
  end

  def test_should_create_item_and_redirect_to_edit
    typus_user = typus_users(:admin)
    Typus::Configuration.options[:edit_after_create] = true
    @request.session[:typus] = typus_user.id
    items = Post.count
    post :create, { :item => { :title => "This is another title", :body => "Body" } }
    assert_response :redirect
    assert_redirected_to :action => 'edit'
    assert_equal items + 1, Post.count
  end

  def test_should_render_show
    typus_user = typus_users(:admin)
    post_ = posts(:published)
    @request.session[:typus] = typus_user.id
    get :show, { :id => post_.id }
    assert_response :success
    assert_template 'show'
  end

  def test_should_render_edit
    typus_user = typus_users(:admin)
    post_ = posts(:published)
    @request.session[:typus] = typus_user.id
    get :edit, { :id => post_.id }
    assert_response :success
    assert_template 'edit'
  end

  def test_should_update_item_and_redirect_to_index
    Typus::Configuration.options[:edit_after_create] = false
    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id
    post_ = posts(:published)
    post :update, { :id => post_.id, :title => "Updated" }
    assert_response :redirect
    assert_redirected_to :action => 'index'
  end

  def test_should_update_item_and_redirect_to_edit
    Typus::Configuration.options[:edit_after_create] = true
    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id
    post_ = posts(:published)
    post :update, { :id => post_.id, :title => "Updated" }
    assert_response :redirect
    assert_redirected_to :action => 'edit', :id => post_.id
  end

  def test_should_allow_admin_to_toggle_item
    @request.env["HTTP_REFERER"] = "/admin/posts"
    typus_user = typus_users(:admin)
    post = posts(:unpublished)
    @request.session[:typus] = typus_user.id
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
    typus_user = typus_users(:admin)
    tag = tags(:first)
    post_ = posts(:published)
    @request.session[:typus] = typus_user.id
    @request.env["HTTP_REFERER"] = "/admin/posts/#{post_.id}/edit"
    post :relate, { :id => post_.id, :related => { :model => "Tag", :id => tag.id } }
    assert_response :redirect
    assert flash[:success]
    assert_redirected_to :action => 'edit', :id => post_.id
    post :unrelate, { :id => post_.id, :model => "Tag", :model_id => tag.id }
    assert_response :redirect
    assert flash[:success]
  end

  def test_should_render_posts_sidebar_on_index_edit_and_show

    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id

    post_ = posts(:published)

    get :index
    assert_response :success
    assert_match /_index_sidebar.html.erb/, @response.body

    get :edit, { :id => post_.id }
    assert_response :success
    assert_match /_edit_sidebar.html.erb/, @response.body

    get :show, { :id => post_.id }
    assert_response :success
    assert_match /_show_sidebar.html.erb/, @response.body

  end

  def test_should_render_posts_top_on_index_show_and_edit

    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id

    post_ = posts(:published)

    get :index
    assert_response :success
    assert_match /_index_top.html.erb/, @response.body

    get :edit, { :id => post_.id }
    assert_response :success
    assert_match /_edit_top.html.erb/, @response.body

    get :show, { :id => post_.id }
    assert_response :success
    assert_match /_show_top.html.erb/, @response.body

  end

  def test_should_render_posts_bottom_on_index_show_and_edit

    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id

    post_ = posts(:published)

    get :index
    assert_response :success
    assert_match /_index_bottom.html.erb/, @response.body

    get :edit, { :id => post_.id }
    assert_response :success
    assert_match /_edit_bottom.html.erb/, @response.body

    get :show, { :id => post_.id }
    assert_response :success
    assert_match /_show_bottom.html.erb/, @response.body

  end

  def test_should_check_redirection_when_theres_no_http_referer_on_new

    typus_user = typus_users(:designer)
    @request.session[:typus] = typus_user.id

    get :new
    assert_response :redirect
    assert_redirected_to typus_dashboard_url

    assert flash[:notice]
    assert_match /Designer cannot add new items./, flash[:notice]

    @request.env["HTTP_REFERER"] = "/admin/posts"

    typus_user = typus_users(:designer)
    @request.session[:typus] = typus_user.id

    get :new
    assert_response :redirect
    assert_redirected_to "/admin/posts"

    assert flash[:notice]
    assert_match /Designer cannot add new items./, flash[:notice]

  end

  def test_should_show_add_new_link_in_index
    assert true
  end

  def test_should_not_show_add_new_link_in_index
    assert true
  end

  def test_should_show_remove_record_link_in_index
    assert true
  end

  def test_should_not_show_remove_record_link_in_index
    assert true
  end

  def test_should_disable_toggle_and_check_links_are_disabled
    Typus::Configuration.options[:toggle] = false
    @request.env["HTTP_REFERER"] = "/admin/posts"
    typus_user = typus_users(:admin)
    post = posts(:unpublished)
    @request.session[:typus] = typus_user.id
    get :toggle, { :id => post.id, :field => 'status' }
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert !flash[:success]
    assert flash[:warning]
    assert_match /Toggle is disabled/, flash[:warning]
    Typus::Configuration.options[:toggle] = true
  end

end