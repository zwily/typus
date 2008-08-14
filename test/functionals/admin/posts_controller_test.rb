require File.dirname(__FILE__) + '/../../test_helper'

class Admin::PostsControllerTest < ActionController::TestCase

  def test_should_redirect_to_login
    get :index
    assert_response :redirect
    assert_redirected_to typus_login_url
    get :edit, { :id => 1 }
    assert_response :redirect
    assert_redirected_to typus_login_url
  end

  def test_should_render_new
    @request.session[:typus] = 1
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_should_create_item
    @request.session[:typus] = 1
    items = Post.count
    post :create, { :item => { :title => "This is another title", :body => "Body" } }
    assert_response :redirect
    assert_redirected_to :action => 'edit'
    assert_equal items + 1, Post.count
  end

  def test_should_render_show
    @request.session[:typus] = 1
    get :show, { :id => 1 }
    assert_response :success
    assert_template 'show'
  end

  def test_should_render_edit
    @request.session[:typus] = 1
    get :edit, { :id => 1 }
    assert_response :success
    assert_template 'edit'
  end

  def test_should_update_item
    @request.session[:typus] = 1
    post :update, { :id => 1, :title => "Updated" }
    assert_response :redirect
    assert_redirected_to :action => 'edit', :id => 1
  end

  def test_should_allow_admin_to_toggle_item
    @request.env["HTTP_REFERER"] = "/admin/posts"
    admin = typus_users(:admin)
    post = posts(:unpublished)
    @request.session[:typus] = admin.id
    get :toggle, { :id => post.id, :field => 'status' }
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert flash[:success]
    assert Post.find(post.id).status
  end

  def test_should_perform_a_search
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    get :index, { :search => 'neinonon' }
    assert_response :success
    assert_template 'index'
  end

  def test_should_relate_a_tag_to_a_post_and_then_unrelate
    @request.session[:typus] = 1
    @request.env["HTTP_REFERER"] = "/admin/posts/1/edit"
    post :relate, { :id => 1, :related => { :model => "Tag", :id => "1"} }
    assert_response :redirect
    assert flash[:success]
    assert_redirected_to :action => 'edit', :id => 1
    post :unrelate, { :id => 1, :model => "Tag", :model_id => "1" }
    assert_response :redirect
    assert flash[:success]
  end

  def test_should_allow_admin_to_destroy_any_post
    assert true
  end

  def test_shold_allow_editor_to_destroy_his_posts
    assert true
  end

  def test_shold_not_allow_editor_to_destroy_other_users_posts
    assert true
  end

end