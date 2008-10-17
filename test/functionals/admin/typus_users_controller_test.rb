require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test what the TypusUsers can do.
#
class Admin::TypusUsersControllerTest < ActionController::TestCase

  def test_should_allow_admin_to_create_typus_users

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

  def test_should_not_allow_admin_to_toggle_her_status

    @request.env["HTTP_REFERER"] = "/admin/typus_users"

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :toggle, { :id => admin.id, :field => 'status' }
    assert_response :redirect
    assert_redirected_to "/admin/typus_users"

    assert flash[:notice]
    assert_match /You cannot toggle your status./, flash[:notice]

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

  def test_should_not_allow_editor_to_create_typus_users

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

    editor = typus_users(:editor)
    @request.session[:typus] = editor.id
    @request.env["HTTP_REFERER"] = "/admin/typus_users/#{editor.id}/edit"

    get :edit, { :id => editor.id }
    assert_response :success

    assert_equal 'editor', editor.roles

    post :update, { :id => editor.id, :item => { :first_name => "Richard", :last_name => "Ashcroft", :roles => "editor" } }
    assert_response :redirect
    assert_redirected_to :action => 'edit', :id => editor.id

    assert flash[:success]
    assert_match /Typus user successfully updated./, flash[:success]

  end

  def test_should_not_allow_editor_to_update_himself_to_become_admin

    Typus::Configuration.options[:root] = 'admin'

    editor = typus_users(:editor)
    @request.session[:typus] = editor.id
    @request.env["HTTP_REFERER"] = "/admin/typus_users/#{editor.id}/edit"

    assert_equal 'editor', editor.roles

    post :update, { :id => editor.id, :item => { :roles => 'admin' } }
    assert_response :redirect
    assert_redirected_to "/admin/typus_users/#{editor.id}/edit"

    assert flash[:error]
    assert_match /Only admin can change roles./, flash[:error]

  end

  # FIXME
  def test_should_not_allow_editor_to_edit_other_users_profiles

    Typus::Configuration.options[:edit_after_create] = true

    user = typus_users(:editor)
    @request.session[:typus] = user.id

    get :edit, { :id => user.id }
    assert_response :success
    assert_template 'edit'

    get :edit, { :id => typus_users(:admin).id }
    assert_response :success
    assert_template 'edit'
    # assert_response :redirect
    # assert_redirected_to :action => :index

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

  def test_should_redirect_to_typus_dashboard_if_user_does_not_have_privileges

    @request.env["HTTP_REFERER"] = "/admin"

    user = typus_users(:designer)
    @request.session[:typus] = user.id

    get :index
    assert_response :redirect
    assert_redirected_to "/admin"

    assert flash[:notice]
    assert_match /You don't have permission to access this resource./, flash[:notice]

  end

end