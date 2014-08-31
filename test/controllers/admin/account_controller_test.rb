require 'test_helper'

=begin

  What's being tested here?

    - Create first user. (/admin/account/new)
    - Stuff that happens when there are already users.

=end

class Admin::AccountControllerTest < ActionController::TestCase

  test 'redirection to new when no users' do
    TypusUser.stubs(:count).returns(0)

    get :new

    assert_response :success
    assert_template 'new'
    assert_template 'layouts/admin/session'
    assert_equal 'Enter your email below to create the first user.', flash[:notice]
  end

  test 'forgot_password redirects to new when no users' do
    TypusUser.stubs(:count).returns(0)
    get :forgot_password
    assert_response :redirect
    assert_redirected_to new_admin_account_path
  end

  test 'send_password redirects to new when no users' do
    TypusUser.stubs(:count).returns(0)
    post :send_password, typus_user: { email: 'john@locke.com' }
    assert_response :redirect
    assert_redirected_to new_admin_account_path
  end

  test 'create with invalid emails redirects to new' do
    TypusUser.stubs(:count).returns(0)

    post :create, typus_user: { email: 'example.com' }

    assert_response :redirect
    assert_redirected_to action: :new
    assert flash.empty?
  end

  test 'create with valid email redirects to user' do
    TypusUser.delete_all

    assert_difference('TypusUser.count') do
      post :create, typus_user: { email: 'john@example.com' }
    end

    assert_response :redirect
    assert_redirected_to action: 'show', id: TypusUser.find_by_email('john@example.com').token
  end

  test 'new redirects to new session when there are users' do
    get :new
    assert_response :redirect
    assert_redirected_to new_admin_session_path
  end

  test 'forgot_password is rendered when there are users' do
    get :forgot_password
    assert_response :success
    assert_template 'forgot_password'
  end

  test 'send_password for unexisting email returns to send_password' do
    post :send_password, typus_user: { email: 'unexisting' }
    assert_response :success
    assert flash.empty?
  end

  test 'send_password for existing email' do
    Typus.stubs(:mailer_sender).returns('typus@example.com')
    typus_user = typus_users(:admin)
    post :send_password, typus_user: { email: typus_user.email }
    assert_response :redirect
    assert_redirected_to new_admin_session_path
    assert_equal 'Password recovery link sent to your email.', flash[:notice]
  end

  test 'show with token generates a session a redirects user to edit' do
    typus_user = typus_users(:admin)
    get :show, id: typus_user.token
    assert_response :redirect
    assert_redirected_to controller: '/admin/typus_users', action: 'edit', id: typus_user.id
  end

  test 'show with token and return_to redirects to user dashboard' do
    typus_user = typus_users(:admin)
    get :show, id: typus_user.token, return_to: '/admin'
    assert_response :redirect
    assert_redirected_to 'http://test.host/admin'
  end

  test 'show with invalid token raises a 404 error' do
    assert_raises ActiveRecord::RecordNotFound do
      get :show, id: 'unexisting'
    end
  end

end
