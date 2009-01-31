require File.dirname(__FILE__) + '/../test_helper'

class AdminControllerTest < ActionController::TestCase

  def setup
    typus_user = typus_users(:admin)
    @request.session[:typus] = typus_user.id
  end

  def test_should_redirect_to_login_if_not_logged
    @request.session[:typus] = nil
    get :overview
    assert_response :redirect
    assert_redirected_to admin_login_url(:back_to => '/admin/overview')
  end

  def test_should_render_dashboard
    get :dashboard
    assert_response :success
    assert_template 'dashboard'
    assert_match "whatistypus.com", @response.body
  end

  def test_should_verify_overview_works
    get :overview
    assert_template 'overview'
    assert_response :success
  end

  def test_should_verify_page_title_on_dashboard
    get :dashboard
    assert_select 'title', "#{Typus::Configuration.options[:app_name]} &rsaquo; Dashboard"
  end

  def test_should_verify_link_to_edit_typus_user
    get :dashboard
    assert_response :success
    assert_match "/admin/typus_users/#{@request.session[:typus]}/edit", @response.body
  end

  def test_should_show_add_links_in_resources_list_for_admin

    get :dashboard

    %w( typus_users posts pages assets ).each do |resource|
      assert_match "/admin/#{resource}/new", @response.body
    end

    %w( statuses orders ).each do |resource|
      assert_no_match /\/admin\/#{resource}\n/, @response.body
    end

  end

  def test_should_show_add_links_in_resources_list_for_editor
    editor = typus_users(:editor)
    @request.session[:typus] = editor.id
    get :dashboard
    assert_match "/admin/posts/new", @response.body
    assert_no_match /\/admin\/typus_users\/new/, @response.body
    # We have loaded categories as a module, so are not displayed 
    # on the applications list.
    assert_no_match /\/admin\/categories\/new/, @response.body
  end

  def test_should_show_add_links_in_resources_list_for_designer
    designer = typus_users(:designer)
    @request.session[:typus] = designer.id
    get :dashboard
    assert_no_match /\/admin\/posts\/new/, @response.body
    assert_no_match /\/admin\/typus_users\/new/, @response.body
  end

  def test_should_render_application_dashboard_sidebar

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :dashboard
    assert_response :success
    assert_match /_sidebar.html.erb/, @response.body

  end

  def test_should_render_application_dashboard_top

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :dashboard
    assert_response :success
    assert_match /_top.html.erb/, @response.body

  end

  def test_should_render_application_dashboard_bottom

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    get :dashboard
    assert_response :success
    assert_match /_bottom.html.erb/, @response.body

  end

end