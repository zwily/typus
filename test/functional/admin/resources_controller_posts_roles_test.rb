require "test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  setup do
    @request.env['HTTP_REFERER'] = '/admin/posts'
  end

  context "Admin" do

    should "be able to add posts" do
      assert @typus_user.can?("create", "Post")
    end

    should "be able to destroy posts" do
      get :destroy, { :id => Factory(:post).id, :method => :delete }

      assert_response :redirect
      assert_equal "Post successfully removed.", flash[:notice]
      assert_redirected_to :action => :index
    end

  end

  context "Designer" do

    setup do
      Typus.user_class.delete_all
      @designer = Factory(:typus_user, :role => "designer")
      @request.session[:typus_user_id] = @designer.id
      @post = Factory(:post)
    end

    should "not be able to add posts" do
      get :new

      assert_response :redirect
      assert_equal "Designer can't perform action. (new)", flash[:notice]
      assert_redirected_to :action => :index
    end

    should_eventually "not be able to destroy posts" do
      get :destroy, { :id => @post.id, :method => :delete }

      assert_response :redirect
      # assert_equal "Designer can't delete this item.", flash[:notice]
      assert_redirected_to :action => :index
    end

  end

end
