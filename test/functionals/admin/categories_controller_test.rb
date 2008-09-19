require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test position action. And roles ...
#
class Admin::CategoriesControllerTest < ActionController::TestCase

  def setup
    user = typus_users(:editor)
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
    assert_match /Record moved lower./, flash[:success]
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
    assert_match /Record moved higher./, flash[:success]
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
    assert_match /Record moved to bottom./, flash[:success]
    first_category = Category.find(1)
    assert_equal first_category.position, 3
  end

  def test_should_position_bottom_item_to_top
    third_category = categories(:third)
    assert_equal third_category.position, 3
    get :position, { :id => third_category.id, :go => 'move_to_top' }
    assert flash[:success]
    assert_match /Record moved to top./, flash[:success]
    third_category = Category.find(3)
    assert_equal third_category.position, 1
  end

  def test_should_allow_admin_to_add_a_category
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    assert admin.can_create? Category
  end

  def test_should_not_allow_designer_to_add_a_category
    designer = typus_users(:designer)
    @request.session[:typus] = designer.id
    category = categories(:first)
    get :new
    assert_response :redirect
    assert flash[:notice]
    assert_match /Designer cannot add new items./, flash[:notice]
    assert_redirected_to :action => :index
  end

  def test_should_allow_admin_to_destroy_a_category
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    category = categories(:first)
    get :destroy, { :id => category.id, :method => :delete }
    assert_response :redirect
    assert flash[:success]
    assert_match /Category successfully removed./, flash[:success]
    assert_redirected_to :action => :index
  end

  def test_should_not_allow_designer_to_destroy_a_category
    designer = typus_users(:designer)
    @request.session[:typus] = designer.id
    category = categories(:first)
    get :destroy, { :id => category.id, :method => :delete }
    assert_response :redirect
    assert flash[:notice]
    assert_match /Designer cannot destroy this item./, flash[:notice]
    assert_redirected_to :action => :index
  end

end