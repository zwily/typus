require 'test/helper'

class Admin::CategoriesControllerTest < ActionController::TestCase

  def setup
    user = typus_users(:editor)
    @request.session[:typus_user_id] = user.id
    @request.env['HTTP_REFERER'] = '/admin/categories'
  end

  def test_should_redirect_to_login

    @request.session[:typus_user_id] = nil

    get :index
    assert_response :redirect
    assert_redirected_to admin_sign_in_path(:back_to => '/admin/categories')

    get :edit, { :id => 1 }
    assert_response :redirect
    assert_redirected_to admin_sign_in_path(:back_to => '/admin/categories')

  end

  def test_should_allow_admin_to_add_a_category
    admin = typus_users(:admin)
    @request.session[:typus_user_id] = admin.id
    assert admin.can_perform?('Category', 'create')
  end

  def test_should_not_allow_designer_to_add_a_category
    designer = typus_users(:designer)
    @request.session[:typus_user_id] = designer.id
    category = categories(:first)
    get :new
    assert_response :redirect
    assert_equal "Designer can't perform action. (new)", flash[:notice]
    assert_redirected_to :action => :index
  end

  def test_should_allow_admin_to_destroy_a_category
    admin = typus_users(:admin)
    @request.session[:typus_user_id] = admin.id
    category = categories(:first)
    get :destroy, { :id => category.id }
    assert_response :redirect
    assert_equal "Category successfully removed.", flash[:success]
    assert_redirected_to :action => :index
  end

  def test_should_not_allow_designer_to_destroy_a_category
    designer = typus_users(:designer)
    @request.session[:typus_user_id] = designer.id
    category = categories(:first)
    get :destroy, { :id => category.id, :method => :delete }
    assert_response :redirect
    assert_equal "Designer can't delete this item.", flash[:notice]
    assert_redirected_to :action => :index
  end

end

class Admin::PostsControllerTest < ActionController::TestCase

  def test_should_verify_root_can_edit_any_record
    Post.find(:all).each do |post|
      get :edit, { :id => post.id }
      assert_response :success
      assert_template 'edit'
    end
  end

  def test_should_verify_editor_can_view_all_records
    Post.find(:all).each do |post|
      get :show, { :id => post.id }
      assert_response :success
      assert_template 'show'
    end
  end

  def test_should_verify_editor_can_edit_their_records

    typus_user = typus_users(:editor)
    @request.session[:typus_user_id] = typus_user.id

    post = posts(:owned_by_editor)
    get :edit, { :id => post.id }
    assert_response :success

  end

  def test_should_verify_editor_cannot_edit_other_users_records

    @request.env['HTTP_REFERER'] = '/admin/posts'

    typus_user = typus_users(:editor)
    @request.session[:typus_user_id] = typus_user.id

    post = posts(:owned_by_admin)
    get :edit, { :id => post.id }
    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert_equal "You don't have permission to access this item.", flash[:notice]

  end

  def test_should_verify_admin_updating_an_item_does_not_change_typus_user_id_if_not_defined
    post_ = posts(:owned_by_editor)
    post :update, { :id => post_.id, :item => { :title => 'Updated by admin' } }
    post_updated = Post.find(post_.id)
    assert_equal post_.typus_user_id, post_updated.typus_user_id
  end

  def test_should_verify_admin_updating_an_item_does_change_typus_user_id_to_whatever_admin_wants
    post_ = posts(:owned_by_editor)
    post :update, { :id => post_.id, :item => { :title => 'Updated', :typus_user_id => 108 } }
    post_updated = Post.find(post_.id)
    assert_equal 108, post_updated.typus_user_id
  end

  def test_should_verify_editor_updating_an_item_does_not_change_typus_user_id

    typus_user = typus_users(:editor)
    @request.session[:typus_user_id] = typus_user.id

    [ 108, nil ].each do |typus_user_id|
      post_ = posts(:owned_by_editor)
      post :update, { :id => post_.id, :item => { :title => 'Updated', :typus_user_id => typus_user_id } }
      post_updated = Post.find(post_.id)
      assert_equal typus_user.id, post_updated.typus_user_id
    end

  end

  def test_should_verify_typus_user_id_of_item_when_creating_record

    typus_user = typus_users(:editor)
    @request.session[:typus_user_id] = typus_user.id

    post :create, { :item => { :title => "Chunky Bacon", :body => "Lorem ipsum ..." } }
    post_ = Post.find_by_title("Chunky Bacon")

    assert_equal typus_user.id, post_.typus_user_id

  end

end