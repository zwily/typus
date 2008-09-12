require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test what the TypusUsers can do.
#
class Admin::TypusUsersControllerTest < ActionController::TestCase

  def test_should_allow_admin_to_create_users

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :new
    assert_response :success

  end

  def test_should_allow_admin_to_update_other_users_profiles

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :new
    assert_response :success

  end

  def test_should_not_allow_admin_to_destroy_himself

    @request.env["HTTP_REFERER"] = "/admin/typus_users"

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    delete :destroy, :id => admin.id
    assert_response :redirect
    assert_redirected_to "/admin/typus_users"

    assert flash[:notice]
    assert_match /You cannot remove yourself from Typus./, flash[:notice]

  end

  def test_should_allow_admin_to_destroy_typus_users

    @request.env["HTTP_REFERER"] = "/admin/typus_users"

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    delete :destroy, :id => typus_users(:editor).id
    assert_response :redirect
    assert_redirected_to "/admin/typus_users"

    assert flash[:success]
    assert_match /Typus user successfully removed./, flash[:success]

  end

  def test_should_not_allow_editor_to_add_typus_users

    @request.env["HTTP_REFERER"] = "/admin/typus_users"

    user = typus_users(:editor)
    @request.session[:typus] = user.id

    get :new
    assert_response :redirect
    assert_redirected_to "/admin/typus_users"

    assert flash[:notice]
    assert_match /Editor cannot add new items./, flash[:notice]

  end

  def test_should_allow_editor_to_update_himself

    Typus::Configuration.options[:edit_after_create] = true

    user = typus_users(:editor)
    @request.session[:typus] = user.id

    get :edit, { :id => user.id }
    assert_response :success

    post :update, { :id => user.id, :item => { :first_name => "Richard", :last_name => "Ashcroft" }}
    assert_response :redirect
    assert_redirected_to :action => 'edit', :id => user.id

    assert flash[:success]
    assert_match /Typus user successfully updated./, flash[:success]

  end

  # FIXME
  def test_should_not_allow_editor_to_edit_other_users_profiles

    Typus::Configuration.options[:edit_after_create] = true

    user = typus_users(:editor)
    @request.session[:typus] = user.id

    get :edit, { :id => typus_users(:admin).id }

  end

  def test_should_not_allow_editor_to_destroy_users

    @request.env["HTTP_REFERER"] = "/admin/typus_users"

    user = typus_users(:editor)
    @request.session[:typus] = user.id

    delete :destroy, :id => typus_users(:admin).id
    assert_response :redirect
    assert_redirected_to "/admin/typus_users"

    assert flash[:notice]
    assert_match /Editor cannot destroy this item./, flash[:notice]

  end

  def test_should_not_allow_editor_to_destroy_himself

    @request.env["HTTP_REFERER"] = "/admin/typus_users"

    user = typus_users(:editor)
    @request.session[:typus] = user.id

    delete :destroy, :id => user.id
    assert_response :redirect
    assert_redirected_to "/admin/typus_users"

    assert flash[:notice]
    assert_match /You cannot remove yourself from Typus./, flash[:notice]

  end

end