require File.dirname(__FILE__) + '/../../test_helper'

class Admin::CategoriesControllerTest < ActionController::TestCase

  def setup
    user = typus_users(:user)
    @request.session[:typus] = user.id
    @request.env["HTTP_REFERER"] = "/admin/categories"
  end

  def test_should_position_item_one_step_down
    first_category = categories(:first)
    assert_equal first_category.position, 1
    second_category = categories(:second)
    assert_equal second_category.position, 2
    get :position, { :id => first_category.id, :go => 'move_lower' }
    assert flash[:success]
    first_category = Category.find(1)
    assert_equal first_category.position, 2
    second_category = Category.find(2)
    assert_equal second_category.position, 1
  end

  def test_should_position_item_one_step_up
    first_category = categories(:first)
    assert_equal first_category.position, 1
    second_category = categories(:second)
    assert_equal second_category.position, 2
    get :position, { :id => second_category.id, :go => 'move_higher' }
    assert flash[:success]
    first_category = Category.find(1)
    assert_equal first_category.position, 2
    second_category = Category.find(2)
    assert_equal second_category.position, 1
  end

  def test_should_position_top_item_to_bottom
    first_category = categories(:first)
    assert_equal first_category.position, 1
    get :position, { :id => first_category.id, :go => 'move_to_bottom' }
    assert flash[:success]
    first_category = Category.find(1)
    assert_equal first_category.position, 3
  end

  def test_should_position_bottom_item_to_top
    third_category = categories(:third)
    assert_equal third_category.position, 3
    get :position, { :id => third_category.id, :go => 'move_to_top' }
    assert flash[:success]
    third_category = Category.find(3)
    assert_equal third_category.position, 1
  end

end