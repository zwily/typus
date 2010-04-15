require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  ##
  # :index
  ##

  def test_should_index_items
    get :index

    assert_response :success
    assert_template 'index'
  end

  ##
  # :new
  ##

  def test_should_new_an_item
    get :new

    assert_response :success
    assert_template 'new'
  end

  ##
  # :create
  ##

  def test_should_create_an_item
    assert_difference 'Post.count' do
      post :create, { :post => { :title => 'This is another title', :body => 'Body' } }
      assert_response :redirect
      assert_redirected_to :controller => 'admin/posts', :action => 'show', :id => Post.last
    end
  end

  def test_should_create_an_item_and_redirect_to_index
    Typus::Resource.expects(:action_after_save).returns("index")

    assert_difference 'Post.count' do
      post :create, { :post => { :title => 'This is another title', :body => 'Body' } }
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end
  end

  ##
  # :show
  ##

  def test_should_show_an_item
    post_ = posts(:published)

    get :show, { :id => post_.id }

    assert_response :success
    assert_template 'show'
  end

  ##
  # :edit
  ##

  def test_should_edit_an_item
    get :edit, { :id => posts(:published) }

    assert_response :success
    assert_template 'edit'
  end

  ##
  # :update
  ##

  def test_should_update_an_item
    post_ = posts(:published)

    post :update, { :id => post_.id, :title => 'Updated' }

    assert_response :redirect
    assert_redirected_to :controller => 'admin/posts', :action => 'show', :id => post_.id
  end

  def test_should_update_an_item_and_redirect_to_index
    Typus::Resource.expects(:action_after_save).returns("index")

    post :update, { :id => posts(:published), :title => 'Updated' }

    assert_response :redirect
    assert_redirected_to :action => 'index'
  end

end
