require "test/test_helper"

class Admin::DashboardControllerTest < ActionController::TestCase

  def test_should_redirect_to_sign_in_when_not_signed_in
    @request.session[:typus_user_id] = nil
    get :index
    assert_response :redirect
    assert_redirected_to admin_sign_in_path
  end

  def test_should_verify_a_removed_role_cannot_sign_in

    typus_user = typus_users(:removed_role)
    @request.session[:typus_user_id] = typus_user.id

    get :index
    assert_response :redirect
    assert_redirected_to admin_sign_in_path
    assert_nil @request.session[:typus_user_id]
    assert_equal "Role does no longer exists.", flash[:notice]

  end

  def test_should_verify_block_users_on_the_fly

    admin = typus_users(:admin)
    @request.session[:typus_user_id] = admin.id
    get :index
    assert_response :success

    # Disable user ...

    admin.status = false
    admin.save

    get :index
    assert_response :redirect
    assert_redirected_to admin_sign_in_path

    assert_equal "Typus user has been disabled.", flash[:notice]
    assert_nil @request.session[:typus_user_id]

  end

  def test_should_render_dashboard

    @request.session[:typus_user_id] = typus_users(:admin).id
    get :index

    assert_response :success
    assert_template "index"

    assert_match "layouts/admin", @controller.inspect

    assert_select "title", "#{Typus.app_name} - Dashboard"

    [ "Typus", 
      %(href="/admin/sign_out"), 
      %(href="/admin/typus_users/edit/#{@request.session[:typus_user_id]}) ].each do |string|
      assert_match string, @response.body
    end

    %w( typus_users posts pages assets ).each { |r| assert_match "/admin/#{r}/new", @response.body }
    %w( statuses orders ).each { |r| assert_no_match /\/admin\/#{r}\n/, @response.body }

    assert_select "body div#header" do
      assert_select "a", "Admin Example"
      assert_select "a", "Sign out"
    end

    partials = %w( _sidebar.html.erb )
    partials.each { |p| assert_match p, @response.body }

  end

  def test_should_show_add_links_in_resources_list_for_editor
    @request.session[:typus_user_id] = typus_users(:editor).id
    get :index
    assert_match "/admin/posts/new", @response.body
    assert_no_match /\/admin\/typus_users\/new/, @response.body
    assert_no_match /\/admin\/categories\/new/, @response.body
  end

  def test_should_show_add_links_in_resources_list_for_designer
    @request.session[:typus_user_id] = typus_users(:designer).id
    get :index
    assert_no_match /\/admin\/posts\/new/, @response.body
    assert_no_match /\/admin\/typus_users\/new/, @response.body
  end

end
