require "test/test_helper"

class Admin::AssetsControllerTest < ActionController::TestCase

  def setup
    @request.session[:typus_user_id] = typus_users(:admin).id
    @post = posts(:published)
  end

  def test_should_test_polymorphic_relationship_message

    get :new, { :back_to => "/admin/posts/#{@post.id}/edit", 
                :resource => @post.class.name, :resource_id => @post.id }

    assert_select 'body div#flash' do
      assert_select 'p', "You're adding a new Asset to Post. Do you want to cancel it?"
      assert_select 'a', "Do you want to cancel it?"
    end

  end

  def test_should_create_a_polymorphic_relationship

    assert_difference('post_.assets.count') do
      post :create, { :back_to => "/admin/posts/edit/#{@post.id}", 
                      :resource => @post.class.name, :resource_id => @post.id }
    end

    assert_response :redirect
    assert_redirected_to '/admin/posts/edit/1#assets'
    assert_equal "Asset successfully assigned to Post.", flash[:notice]

  end

  def test_should_render_edit_and_verify_message_on_polymorphic_relationship

    get :edit, { :id => assets(:first).id, 
                 :back_to => "/admin/posts/#{@post.id}/edit", 
                 :resource => @post.class.name, :resource_id => @post.id }

    assert_select 'body div#flash' do
      assert_select 'p', "You're updating a Asset for Post. Do you want to cancel it?"
      assert_select 'a', "Do you want to cancel it?"
    end

  end

  def test_should_return_to_back_to_url
    Typus::Resource.expects(:action_after_save).returns(:edit)
    asset = assets(:first)

    post :update, { :back_to => "/admin/posts/#{@post.id}/edit", :resource => @post.class.name, :resource_id => @post.id, :id => asset.id }
    assert_response :redirect
    assert_redirected_to '/admin/posts/1/edit#assets'
    assert_equal "Asset successfully updated.", flash[:notice]
  end

end
