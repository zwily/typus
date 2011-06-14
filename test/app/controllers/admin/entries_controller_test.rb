require "test_helper"

=begin

  What's being tested here?

    - CRUD: Create, read, update, destroy
    - CRUD Extras: toggle
    - Typus::Controller::Trash (Which probably shoould be moved somewhere else)

=end

class Admin::EntriesControllerTest < ActionController::TestCase

  setup do
    admin_sign_in
    @entry = Factory(:entry)
  end

  test "get index" do
    get :index
    assert_response :success
    assert_template 'index'
  end

  test "get new" do
    get :new
    assert_response :success
    assert_template 'new'
  end

  test "get new and reject params which are not included in @resource.columns.map(&:name)" do
    %w(chunky_bacon).each do |param|
      get :new, { param => param }
      assert_response :success
      assert_template 'new'
    end
  end

  test "post create and redirect to index" do
    assert_difference('Entry.count') do
      post :create, :entry => @entry.attributes, :_save => true
      assert_response :redirect
      assert_redirected_to "/admin/entries"
    end
  end

  test "post create and redirect to add new" do
    assert_difference('Entry.count') do
      post :create, :entry => @entry.attributes, :_addanother => true
      assert_response :redirect
      assert_redirected_to "/admin/entries/new"
    end
  end

  test "post create and continue editing" do
    assert_difference('Entry.count') do
      post :create, :entry => @entry.attributes, :_continue => true
      assert_response :redirect
      assert_redirected_to "/admin/entries/edit/#{Entry.last.id}"
    end
  end

  test "get show" do
    get :show, :id => @entry.id
    assert_response :success
    assert_template 'show'
  end

  test "get edit" do
    get :edit, :id => @entry.id
    assert_response :success
    assert_template 'edit'
  end

  test "post update and redirect to index" do
    post :update, :id => @entry.id, :entry => { :title => 'Updated' }, :_save => true
    assert_response :redirect
    assert_redirected_to "/admin/entries"
  end

  test "get toggle" do
    @request.env['HTTP_REFERER'] = "/admin/entries"

    assert !@entry.published
    get :toggle, :id => @entry.id, :field => "published"

    assert_response :redirect
    assert_redirected_to @request.env["HTTP_REFERER"]
    assert_equal "Entry successfully updated.", flash[:notice]
    assert @entry.reload.published
  end

  test "get toggle redirects to edit because validation has failed" do
    @request.env['HTTP_REFERER'] = "/admin/entries"

    @entry.content = nil
    @entry.save(:validate => false)
    get :toggle, :id => @entry.id, :field => "published"
    assert_response :success
    assert_template "admin/resources/edit"
  end

  test "get trash lists destroyed items" do
    get :trash
    assert assigns(:items).empty?

    @entry.destroy
    get :trash
    assert_response :success
    assert_template 'admin/resources/index'
    assert_equal [@entry], assigns(:items)
  end

  test "get restore recovers an item from the trash" do
    @request.env['HTTP_REFERER'] = "/admin/entries/trash"

    @entry.destroy
    get :restore, :id => @entry.id
    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']

    get :trash
    assert assigns(:items).empty?
  end

end
