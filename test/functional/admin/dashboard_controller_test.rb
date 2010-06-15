require "test/test_helper"

class Admin::DashboardControllerTest < ActionController::TestCase

  context "Not logged" do

    setup do
      @request.session[:typus_user_id] = nil
    end

    should "redirect_to_sign_in_when_not_signed_in" do
      get :show
      assert_response :redirect
      assert_redirected_to new_admin_session_path
    end

  end

  should "verify_a_removed_role_cannot_sign_in" do
    typus_user = typus_users(:removed_role)
    @request.session[:typus_user_id] = typus_user.id

    get :show

    assert_response :redirect
    assert_redirected_to new_admin_session_path
    assert @request.session[:typus_user_id].nil?
    assert_equal "Role does no longer exists.", flash[:notice]
  end

  should "verify_block_users_on_the_fly" do
    admin = typus_users(:admin)
    @request.session[:typus_user_id] = admin.id

    get :show
    assert_response :success

    # Disable user ...

    admin.status = false
    admin.save

    get :show

    assert_response :redirect
    assert_redirected_to new_admin_session_path
    assert_equal "Typus user has been disabled.", flash[:notice]
    assert @request.session[:typus_user_id].nil?
  end

  should "render_dashboard" do

    @request.session[:typus_user_id] = typus_users(:admin).id

    get :show

    assert_response :success
    assert_template "show"

    assert_match "layouts/admin", @controller.inspect

    assert_select "title", "Dashboard"

    [ "Typus", 
      %(href="/admin/session"), 
      %(href="/admin/typus_users/edit/#{@request.session[:typus_user_id]}) ].each do |string|
      assert_match string, @response.body
    end

    %w( typus_users posts pages assets ).each { |r| assert_match "/admin/#{r}/new", @response.body }
    %w( statuses orders ).each { |r| assert_no_match /\/admin\/#{r}\n/, @response.body }

    partials = %w( _sidebar.html.erb )
    partials.each { |p| assert_match p, @response.body }

  end

  should "show_add_links_in_resources_list_for_designer" do
    @request.session[:typus_user_id] = typus_users(:designer).id

    get :show

    assert_no_match /\/admin\/posts\/new/, @response.body
    assert_no_match /\/admin\/typus_users\/new/, @response.body
  end

end
