require 'test/helper'

class Admin::CategoriesControllerTest < ActionController::TestCase

  def setup
    user = typus_users(:editor)
    @request.session[:typus_user_id] = user.id
    @request.env['HTTP_REFERER'] = '/admin/categories'
  end

  if defined?(ActiveRecord::Acts::List)

    def test_should_position_item_one_step_down
      first_category = categories(:first)
      assert_equal 1, first_category.position
      second_category = categories(:second)
      assert_equal 2, second_category.position
      get :position, { :id => first_category.id, :go => 'move_lower' }
      assert_equal "Record moved lower.", flash[:success]
      assert_equal 2, first_category.reload.position
      assert_equal 1, second_category.reload.position
    end

    def test_should_position_item_one_step_up
      return if !defined?(ActiveRecord::Acts::List)
      first_category = categories(:first)
      assert_equal 1, first_category.position
      second_category = categories(:second)
      assert_equal 2, second_category.position
      get :position, { :id => second_category.id, :go => 'move_higher' }
      assert_equal "Record moved higher.", flash[:success]
      assert_equal 2, first_category.reload.position
      assert_equal 1, second_category.reload.position
    end

    def test_should_position_top_item_to_bottom
      return if !defined?(ActiveRecord::Acts::List)
      first_category = categories(:first)
      assert_equal 1, first_category.position
      get :position, { :id => first_category.id, :go => 'move_to_bottom' }
      assert_equal "Record moved to bottom.", flash[:success]
      assert_equal 3, first_category.reload.position
    end

    def test_should_position_bottom_item_to_top
      return if !defined?(ActiveRecord::Acts::List)
      third_category = categories(:third)
      assert_equal 3, third_category.position
      get :position, { :id => third_category.id, :go => 'move_to_top' }
      assert_equal "Record moved to top.", flash[:success]
      assert_equal 1, third_category.reload.position
    end

  end

end