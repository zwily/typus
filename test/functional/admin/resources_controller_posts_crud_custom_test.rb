require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  context "Overwrite action_after_save" do

    setup do
      Typus::Resource.expects(:action_after_save).returns("index")
    end

    should "update_an_item_and_redirect_to_index" do
      post :update, { :id => posts(:published), :title => 'Updated' }
      assert_response :redirect
      assert_redirected_to :action => 'index'
    end

    should "create_an_item_and_redirect_to_index" do
      assert_difference 'Post.count' do
        post :create, { :post => { :title => 'This is another title', :body => 'Body' } }
        assert_response :redirect
        assert_redirected_to :action => 'index'
      end
    end

  end

end
