require "test_helper"

=begin

  What's being tested here?

    - ActsAsList.
    - Template Override (TODO: Centralize this!!!)
    - Unrelate (Post#categories) (has_and_belongs_to_many)

=end

class Admin::CategoriesControllerTest < ActionController::TestCase

  setup do
    @request.session[:typus_user_id] = Factory(:typus_user).id
    @request.env['HTTP_REFERER'] = '/admin/categories'
  end

  context "Categories Views" do

    should "verify form partial can overrided by model" do
      get :new
      assert_match "categories#_form.html.erb", @response.body
    end

  end

  context "Categories List" do

    setup do
      @first_category = Factory(:category, :position => 1)
      @second_category = Factory(:category, :position => 2)
    end

    should "verify referer" do
      get :position, { :id => @first_category.id, :go => 'move_lower' }
      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
    end

    should "position item one step down" do
      get :position, { :id => @first_category.id, :go => 'move_lower' }

      assert_equal "Record moved to position lower.", flash[:notice]
      assert_equal 2, @first_category.reload.position
      assert_equal 1, @second_category.reload.position
    end

    should "position item one step up" do
      get :position, { :id => @second_category.id, :go => 'move_higher' }

      assert_equal "Record moved to position higher.", flash[:notice]
      assert_equal 2, @first_category.reload.position
      assert_equal 1, @second_category.reload.position
    end

    should "position top item to bottom" do
      get :position, { :id => @first_category.id, :go => 'move_to_bottom' }
      assert_equal "Record moved to position to bottom.", flash[:notice]
      assert_equal 2, @first_category.reload.position
    end

    should "position bottom item to top" do
      get :position, { :id => @second_category.id, :go => 'move_to_top' }
      assert_equal "Record moved to position to top.", flash[:notice]
      assert_equal 1, @second_category.reload.position
    end

  end

  context "Unrelate (has_and_belongs_to_many)" do

    ##
    # We are in:
    #
    #   /admin/posts/edit/1
    #
    # And we see a list of comments under it:
    #
    #   /admin/categories/unrelate/1?resource=Post&resource_id=1
    #   /admin/categories/unrelate/2?resource=Post&resource_id=1
    ##

    setup do
      @category = Factory(:category)
      @category.posts << Factory(:post)
      @request.env['HTTP_REFERER'] = "/admin/dashboard"
    end

    should "unrelate category from post" do
      assert_difference('@category.posts.count', -1) do
        post :unrelate, { :id => @category.id, :resource => 'Post', :resource_id => @category.posts.first }
      end

      assert_response :redirect
      assert_redirected_to @request.env['HTTP_REFERER']
      assert_equal "Category successfully updated.", flash[:notice]
    end

  end

  context "create_with_back_to (for belongs_to)" do

    setup do
      @post = Factory(:post)
    end

    should "create a comment and assign it to post" do
      category = {:name => "Category#1"}
      back_to = "/admin/posts/edit/#{@post.id}"

      assert_difference('@post.categories.count') do
       post :create, { :category => category, :back_to => back_to, :resource => "Post", :resource_id => @post.id }
      end

      assert_response :redirect
      assert_redirected_to back_to
      assert_equal "Post successfully updated.", flash[:notice]
    end

  end

end
