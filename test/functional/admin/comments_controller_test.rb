require "test_helper"

=begin

  What's being tested here?

    - Unrelate "Comment" from "Post", where "Comment" belongs_to "Post".
    - Create a "Comment" using the link provided when editing a "Post", this
      will make the created "Comment" to be assigned to the "Post".

=end

class Admin::CommentsControllerTest < ActionController::TestCase

  setup do
    @request.session[:typus_user_id] = Factory(:typus_user).id
    @request.env['HTTP_REFERER'] = '/admin/categories'
  end

  context "create_with_back_to (for belongs_to)" do

    setup do
      @post = Factory(:post)
    end

    should "create a comment and assign it to post" do
      comment = {:name => "John", :email => "john@example.com", :body => "This is the body"}
      back_to = "/admin/posts/edit/#{@post.id}"

      assert_difference('@post.comments.count') do
       post :create, { :comment => comment, :back_to => back_to, :resource => "Post", :resource_id => @post.id }
      end

      assert_response :redirect
      assert_redirected_to back_to
      assert_equal "Post successfully updated.", flash[:notice]
    end

  end

  context "Unrelate (belongs_to)" do

    ##
    # We are in:
    #
    #   /admin/posts/edit/1
    #
    # And we see a list of comments under it:
    #
    #   /admin/comments/unrelate/1?resource=Post&resource_id=1
    #   /admin/comments/unrelate/2?resource=Post&resource_id=1
    ##

    should "unrelate comment from post" do
      comment = Factory(:comment)
      @post = comment.post

      assert_difference('@post.comments.count', -1) do
        post :unrelate, { :id => comment.id, :resource => 'Post', :resource_id => @post.id }
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Comment successfully updated.", flash[:notice]
    end

  end

end
