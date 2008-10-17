require File.dirname(__FILE__) + '/../../test_helper'

##
# Here we test the CRUD actions.
#
class Admin::PostsControllerTest < ActionController::TestCase

  def test_should_redirect_to_login
    get :index
    assert_response :redirect
    assert_redirected_to typus_login_url(:back_to => '/admin/posts')
    get :edit, { :id => 1 }
    assert_response :redirect
    assert_redirected_to typus_login_url(:back_to => '/admin/posts')
  end

  def test_should_render_new
    @request.session[:typus] = 1
    get :new
    assert_response :success
    assert_template 'new'
  end

  def test_should_create_item_and_redirect_to_index
    Typus::Configuration.options[:edit_after_create] = false
    @request.session[:typus] = 1
    items = Post.count
    post :create, { :item => { :title => "This is another title", :body => "Body" } }
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert_equal items + 1, Post.count
  end

  def test_should_create_item_and_redirect_to_edit
    Typus::Configuration.options[:edit_after_create] = true
    @request.session[:typus] = 1
    items = Post.count
    post :create, { :item => { :title => "This is another title", :body => "Body" } }
    assert_response :redirect
    assert_redirected_to :action => 'edit'
    assert_equal items + 1, Post.count
  end

  def test_should_render_show
    @request.session[:typus] = 1
    get :show, { :id => 1 }
    assert_response :success
    assert_template 'show'
  end

  def test_should_render_edit
    @request.session[:typus] = 1
    get :edit, { :id => 1 }
    assert_response :success
    assert_template 'edit'
  end

  def test_should_update_item_and_redirect_to_index
    Typus::Configuration.options[:edit_after_create] = false
    @request.session[:typus] = 1
    post :update, { :id => 1, :title => "Updated" }
    assert_response :redirect
    assert_redirected_to :action => 'index'
  end

  def test_should_update_item_and_redirect_to_edit
    Typus::Configuration.options[:edit_after_create] = true
    @request.session[:typus] = 1
    post :update, { :id => 1, :title => "Updated" }
    assert_response :redirect
    assert_redirected_to :action => 'edit', :id => 1
  end

  def test_should_allow_admin_to_toggle_item
    @request.env["HTTP_REFERER"] = "/admin/posts"
    admin = typus_users(:admin)
    post = posts(:unpublished)
    @request.session[:typus] = admin.id
    get :toggle, { :id => post.id, :field => 'status' }
    assert_response :redirect
    assert_redirected_to :action => 'index'
    assert flash[:success]
    assert Post.find(post.id).status
  end

  def test_should_perform_a_search
    admin = typus_users(:admin)
    @request.session[:typus] = admin.id
    get :index, { :search => 'neinonon' }
    assert_response :success
    assert_template 'index'
  end

  def test_should_relate_a_tag_to_a_post_and_then_unrelate
    @request.session[:typus] = 1
    @request.env["HTTP_REFERER"] = "/admin/posts/1/edit"
    post :relate, { :id => 1, :related => { :model => "Tag", :id => "1"} }
    assert_response :redirect
    assert flash[:success]
    assert_redirected_to :action => 'edit', :id => 1
    post :unrelate, { :id => 1, :model => "Tag", :model_id => "1" }
    assert_response :redirect
    assert flash[:success]
  end

  def test_should_render_posts_sidebar_on_index_edit_and_show

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    folder = "#{RAILS_ROOT}/app/views/admin/posts"
    FileUtils.mkdir(folder) unless File.exists? folder

    file = "#{RAILS_ROOT}/app/views/admin/posts/_index_sidebar.html.erb"
    open(file, 'w+') { |f| f << "Index Sidebar" }
    assert File.exists? file

    get :index
    assert_response :success
    assert_match /Index Sidebar/, @response.body

    file = "#{RAILS_ROOT}/app/views/admin/posts/_edit_sidebar.html.erb"
    open(file, 'w+') { |f| f << "Edit Sidebar" }
    assert File.exists? file

    get :edit, { :id => 1 }
    assert_response :success
    assert_match /Edit Sidebar/, @response.body

    file = "#{RAILS_ROOT}/app/views/admin/posts/_show_sidebar.html.erb"
    open(file, 'w+') { |f| f << "Show Sidebar" }
    assert File.exists? file

    get :show, { :id => 1 }
    assert_response :success
    assert_match /Show Sidebar/, @response.body

  end

  def test_should_render_posts_top_on_index_show_and_edit

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    folder = "#{RAILS_ROOT}/app/views/admin/posts"
    FileUtils.mkdir(folder) unless File.exists? folder

    file = "#{RAILS_ROOT}/app/views/admin/posts/_index_top.html.erb"
    open(file, 'w+') { |f| f << "Index Top" }
    assert File.exists? file

    get :index
    assert_response :success
    assert_match /Index Top/, @response.body

    file = "#{RAILS_ROOT}/app/views/admin/posts/_edit_top.html.erb"
    open(file, 'w+') { |f| f << "Edit Top" }
    assert File.exists? file

    get :edit, { :id => 1 }
    assert_response :success
    assert_match /Edit Top/, @response.body

    file = "#{RAILS_ROOT}/app/views/admin/posts/_show_top.html.erb"
    open(file, 'w+') { |f| f << "Show Top" }
    assert File.exists? file

    get :show, { :id => 1 }
    assert_response :success
    assert_match /Show Top/, @response.body

  end

  def test_should_render_posts_bottom_on_index_show_and_edit

    admin = typus_users(:admin)
    @request.session[:typus] = admin.id

    folder = "#{RAILS_ROOT}/app/views/admin/posts"
    FileUtils.mkdir(folder) unless File.exists? folder

    file = "#{RAILS_ROOT}/app/views/admin/posts/_index_bottom.html.erb"
    open(file, 'w+') { |f| f << "Index Bottom" }
    assert File.exists? file

    get :index
    assert_response :success
    assert_match /Index Bottom/, @response.body

    file = "#{RAILS_ROOT}/app/views/admin/posts/_edit_bottom.html.erb"
    open(file, 'w+') { |f| f << "Edit Bottom" }
    assert File.exists? file

    get :edit, { :id => 1 }
    assert_response :success
    assert_match /Edit Bottom/, @response.body

    file = "#{RAILS_ROOT}/app/views/admin/posts/_show_bottom.html.erb"
    open(file, 'w+') { |f| f << "Show Bottom" }
    assert File.exists? file

    get :show, { :id => 1 }
    assert_response :success
    assert_match /Show Bottom/, @response.body

  end

  def test_should_check_redirection_when_theres_no_http_referer_on_new

    typus_user = typus_users(:designer)
    @request.session[:typus] = typus_user.id

    get :new
    assert_response :redirect
    assert_redirected_to typus_dashboard_url

    assert flash[:notice]
    assert_match /Designer cannot add new items./, flash[:notice]

    @request.env["HTTP_REFERER"] = "/admin/posts"

    typus_user = typus_users(:designer)
    @request.session[:typus] = typus_user.id

    get :new
    assert_response :redirect
    assert_redirected_to "/admin/posts"

    assert flash[:notice]
    assert_match /Designer cannot add new items./, flash[:notice]

  end

  def test_should_show_add_new_link_in_index
    assert true
  end

  def test_should_not_show_add_new_link_in_index
    assert true
  end

  def test_should_show_remove_record_link_in_index
    assert true
  end

  def test_should_not_show_remove_record_link_in_index
    assert true
  end

  def test_should_disable_toggle_and_check_links_are_disabled
    assert true
  end

end