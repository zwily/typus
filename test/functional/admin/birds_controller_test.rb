require "test_helper"

=begin

  What's being tested here?

    - Polymorphic relationships.

=end

class Admin::BirdsControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id
  end

=begin

  should "verify polymorphic relationship message" do
    get :new, { :back_to => "/admin/posts/#{@post.id}/edit",
                :resource => @post.class.name, :resource_id => @post.id }

    assert_select 'body div#flash', "Cancel adding a new asset?"
  end

  context "create polymorphic association" do

    should_eventually "work"

  end

  context "Unrelate (polymorphic relationship)" do

    ##
    # We are in:
    #
    #   /admin/posts/edit/1
    #
    # And we see a list of comments under it:
    #
    #   /admin/assets/unrelate/1?resource=Post&resource_id=1
    #   /admin/assets/unrelate/2?resource=Post&resource_id=1
    ##

    setup do
      @asset = Factory(:asset)
      @post = Factory(:post)
      @post.assets << @asset
    end

    should "unrelate asset from post (which is a resource)" do
      assert_difference('@post.assets.count', -1) do
        post :unrelate, { :id => @asset.id, :resource => 'Post', :resource_id => @post.id }
      end
    end

  end

=end

end
