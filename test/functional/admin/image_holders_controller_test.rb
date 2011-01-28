require "test_helper"

=begin

  What's being tested here?

    - Polymorphic relationships.

=end

class Admin::ImageHoldersControllerTest < ActionController::TestCase

  setup do
    @typus_user = Factory(:typus_user)
    @request.session[:typus_user_id] = @typus_user.id
  end

=begin

  should "relate asset to post (has_many - polymorphic)" do
    asset = Factory(:asset)
    id = asset.id
    @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{@post.id}#assets"

    assert_difference('@post.assets.count') do
      post :relate, { :id => @post.id, :related => { :model => 'Asset', :id => asset.id, :association_name => 'assets' } }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Post successfully updated.", flash[:notice]
  end

=end

end
