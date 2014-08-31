require 'feature_test_helper'

class LoginTest < Capybara::Rails::TestCase

  fixtures :typus_users

  before do
    @user = typus_users(:admin)
    @user.password = "12345678"
  end

  test 'Successful login' do
    visit root_path
    fill_in('Email', with: @user.email)
    fill_in('Password', with: @user.password)
    click_on 'Sign in'
    assert_css 'h2', text: 'Welcome!'
  end
end
