require 'feature_test_helper'

class LoginTest < Capybara::Rails::TestCase

  before do
    @user = TypusUser.where(role: 'admin').first
  end

  test 'Successful login' do
    visit root_path
    fill_in('Email', with: @user.email)
    fill_in('Password', with: @user.password)
    click_on 'Sign in'
    assert_css 'h2', text: 'Welcome!'
  end
end
