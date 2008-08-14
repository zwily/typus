require File.dirname(__FILE__) + '/../../test_helper'

class Admin::PostsControllerTest < ActionController::TestCase

  def test_should_redirect_to_login
    get :index
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

    post :create, { :item => { :title => "This is another title", 
                               :body => "This is the body.", 
                               :category => 1 } }
#    assert_response :redirect
#    assert_redirected_to :action => 'edit'
#    assert_equal items + 1, Post.count
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
    assert_response :success
    # assert_redirected_to :action => 'edit'
  end

end