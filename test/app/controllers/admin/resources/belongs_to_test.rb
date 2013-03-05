require "test_helper"

=begin

  What's being tested here?

    - Belongs To

=end

class Admin::ProjectsControllerTest < ActionController::TestCase

  setup do
    admin_sign_in
  end

  test 'get new reads params[:resource] and allows the usage of _id' do
    get :new, { :resource => { :user_id => 1 } }
    assert_response :success
    assert_template 'new'
    assert_equal 1, assigns(:item).user_id
  end

  test 'get new reads params[:resource]' do
    get :new, { :resource => { :user_id => 1, :name => 'Chunky Bacon'} }
    assert_response :success
    assert_template 'new'
    assert_equal 'Chunky Bacon', assigns(:item).name
  end

end
