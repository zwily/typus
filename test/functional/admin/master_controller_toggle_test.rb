require 'test/helper'

class Admin::PostsControllerTest < ActionController::TestCase

  def setup
    typus_user = typus_users(:admin)
    @request.session[:typus_user_id] = typus_user.id
    @request.env['HTTP_REFERER'] = '/admin/posts'
  end

  def test_should_toggle_an_item

    post = posts(:unpublished)
    get :toggle, { :id => post.id, :field => 'status' }

    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert_equal "Post status changed.", flash[:success]
    assert Post.find(post.id).status

  end

  def test_should_not_toggle_an_item_when_disabled

    options = Typus::Configuration.options.merge(:toggle => false)
    Typus::Configuration.stubs(:options).returns(options)

    post = posts(:unpublished)
    get :toggle, { :id => post.id, :field => 'status' }

    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert_equal "Toggle is disabled.", flash[:notice]

  end

end