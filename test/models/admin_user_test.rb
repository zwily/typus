require "test_helper"

=begin

  Here we test:

  - Typus::Orm::ActiveRecord::AdminUser
  - Typus::Orm::ActiveRecord::User::ClassMethods

=end

class AdminUserTest < ActiveSupport::TestCase

  test 'token changes every time we save the user' do
    admin = typus_users(:admin)
    first_token = admin.token
    admin.save
    second_token = admin.token
    refute first_token.eql?(second_token)
  end

  test 'mapping locales' do
    typus_user = typus_users(:admin)
    typus_user.locale = 'en'
    assert_equal 'English', typus_user.mapping(:locale)
  end

  test 'locales' do
    assert_equal Typus::I18n.available_locales, AdminUser.locales
  end

  test 'roles' do
    assert_equal Typus::Configuration.roles.keys.sort, AdminUser.roles
  end

  test 'validate :password' do
    typus_user = typus_users(:admin)
    assert typus_user.valid?
    typus_user.password = '00000'
    refute typus_user.valid?
    assert_equal 'is too short (minimum is 6 characters)', typus_user.errors[:password].first
    typus_user.password = '000000'
    assert typus_user.valid?
  end

end
