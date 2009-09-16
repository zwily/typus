require 'test/helper'

class Admin::AssetsControllerTest < ActionController::TestCase

  def setup
    typus_user = typus_users(:admin)
    @request.session[:typus_user_id] = typus_user.id
  end

  def test_should_test_polymorphic_relationship_message
    post_ = posts(:published)
    get :new, { :back_to => "/admin/posts/#{post_.id}/edit", :resource => post_.class.name, :resource_id => post_.id }
    assert_match "You're adding a new Asset to Post.", @response.body
  end

  def test_should_create_a_polymorphic_relationship

    post_ = posts(:published)

    assert_difference('post_.assets.count') do
      post :create, { :back_to => "/admin/posts/edit/#{post_.id}", :resource => post_.class.name, :resource_id => post_.id }
    end

    assert_response :redirect
    assert_redirected_to '/admin/posts/edit/1#assets'
    assert flash[:success]
    assert_equal "Asset successfully assigned to Post.", flash[:success]

  end

  def test_should_test_polymorphic_relationship_edit_message
    post_ = posts(:published)
    asset_ = assets(:first)
    get :edit, { :id => asset_.id, :back_to => "/admin/posts/#{post_.id}/edit", :resource => post_.class.name, :resource_id => post_.id }
    assert_match "You're updating a Asset for Post.", @response.body
  end

  def test_should_return_to_back_to_url

    options = Typus::Configuration.options.merge(:index_after_save => true)
    Typus::Configuration.stubs(:options).returns(options)

    post_ = posts(:published)
    asset_ = assets(:first)

    post :update, { :back_to => "/admin/posts/#{post_.id}/edit", :resource => post_.class.name, :resource_id => post_.id, :id => asset_.id }
    assert_response :redirect
    assert_redirected_to '/admin/posts/1/edit#assets'
    assert flash[:success]
    assert_equal "Asset successfully updated.", flash[:success]

  end

end

class Admin::PostsControllerTest < ActionController::TestCase

  def setup
    typus_user = typus_users(:admin)
    @request.session[:typus_user_id] = typus_user.id
  end

  def test_should_unrelate_category_from_post_which_is_a_habtm_relationship
    category = categories(:first)
    post_ = posts(:published)
    @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#categories"
    assert_difference('category.posts.count', 0) do
      post :unrelate, { :id => post_.id, :resource => 'Category', :resource_id => category.id, :association => 'has_and_belongs_to_many' }
    end
    assert_response :redirect
    assert flash[:success]
    assert_match /Category unrelated from/, flash[:success]
    assert_redirected_to @request.env['HTTP_REFERER']
  end

  ##
  # This is a polimorphic relationship.
  #
  def test_should_unrelate_an_asset_from_a_post

    post_ = posts(:published)

    @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#assets"

    assert_difference('post_.assets.count', -1) do
      get :unrelate, { :id => post_.id, :resource => 'Asset', :resource_id => post_.assets.first.id, :association => 'has_many' }
    end

    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']
    assert flash[:success]
    assert_equal "Asset unrelated from Post.", flash[:success]

  end

  def test_should_relate_category_to_post_which_is_a_habtm_relationship
    category = categories(:first)
    post_ = posts(:published)
    @request.env['HTTP_REFERER'] = "/admin/posts/edit/#{post_.id}#categories"
    assert_difference('category.posts.count') do
      post :relate, { :id => post_.id, :related => { :model => 'Category', :id => category.id } }
    end
    assert_response :redirect
    assert flash[:success]
    assert_redirected_to @request.env['HTTP_REFERER']
  end

end