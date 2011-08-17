require "test_helper"

=begin

  What's being tested here?

    - Typus::Controller::Associations

=end

class Admin::CategoriesControllerTest < ActionController::TestCase

  setup do
    @request.session[:typus_user_id] = FactoryGirl.create(:typus_user).id
    @request.env['HTTP_REFERER'] = '/admin/categories'
  end

  ##
  # We are in:
  #
  #   /admin/posts/edit/1
  #
  # And we see a list of comments under it:
  #
  #   /admin/categories/unrelate/1?resource=Post&resource_id=1
  #   /admin/categories/unrelate/2?resource=Post&resource_id=1
  #
  test "unrelate (has_and_belongs_to_many)" do
    category = FactoryGirl.create(:category)
    category.posts << FactoryGirl.create(:post)
    @request.env['HTTP_REFERER'] = "/admin/dashboard"

    assert_difference('category.posts.count', -1) do
      post :unrelate, :id => category.id, :resource => 'Post', :resource_id => category.posts.first
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "Post successfully updated.", flash[:notice]
  end

  ##
  # Basically we verify Admin::ResourcesController#create_with_back_to works
  # as expected for STI models.
  #
  # We are editing a Case (which is an STI model). And we click on "Add New"
  # to add a new category. Once created, we will be redirected and the new
  # category will be assigned to the current case. Easy right?
  #
  test "relate using add new on sti models" do
    category = { :name => "Category Name" }
    kase = FactoryGirl.create(:case)

    assert_difference('kase.categories.count') do
      post :create, { :category => category, :resource => "Case", :resource_id => kase.id, :_saveandassign => true }
    end
  end

end
