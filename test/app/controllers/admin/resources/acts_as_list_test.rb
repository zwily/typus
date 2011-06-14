require "test_helper"

=begin

  What's being tested here?

    - Typus::Controller::ActsAsList

=end

class Admin::CategoriesControllerTest < ActionController::TestCase

  setup do
    @request.session[:typus_user_id] = Factory(:typus_user).id
    @request.env['HTTP_REFERER'] = '/admin/categories'
  end

  test "get position" do
    first_category = Factory(:category, :position => 1)
    second_category = Factory(:category, :position => 2)

    second_category.name = nil
    second_category.save(:validate => false)

    # "verify referer"
    get :position, :id => first_category.id, :go => 'move_lower'
    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']

    # "position item one step down"
    get :position, :id => first_category.id, :go => 'move_lower'
    assert_equal "Category successfully updated.", flash[:notice]
    assert assigns(:item).position.eql?(2)

    # "position item one step up"
    get :position, :id => second_category.id, :go => 'move_higher'
    assert assigns(:item).position.eql?(1)

    # "position top item to bottom"
    get :position, :id => first_category.id, :go => 'move_to_bottom'
    assert assigns(:item).position.eql?(2)

    # "position bottom item to top"
    get :position, :id => second_category.id, :go => 'move_to_top'
    assert assigns(:item).position.eql?(1)
  end

end
