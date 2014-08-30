require "test_helper"

=begin

  Here we test:

  - Typus::Orm::ActiveRecord::AdminUserV1

=end

class TypusUserTest < ActiveSupport::TestCase

  test 'validate email' do
    typus_user = typus_users(:admin)
    assert typus_user.valid?

    typus_user.email = 'dong'
    refute typus_user.valid?

    typus_user.email = nil
    refute typus_user.valid?
  end

  test 'validate :role' do
    typus_user = typus_users(:admin)
    typus_user.role = nil
    assert typus_user.invalid?
  end

  test 'validate :password' do
    typus_user = typus_users(:admin)

    typus_user.password = '0' * 5
    assert typus_user.invalid?

    typus_user.password = '0' * 6
    assert typus_user.valid?
  end

  # test 'generate' do
  #   refute TypusUser.generate
  #
  #   options = { email: 'new.user@example.com' }
  #   typus_user = TypusUser.generate(options)
  #   assert_equal options[:email], typus_user.email
  #
  #   typus_user_factory = typus_users(:admin)
  #   options = { email: typus_user_factory.email, password: typus_user_factory.password }
  #   typus_user = TypusUser.generate(options)
  #   assert_equal options[:email], typus_user.email
  #
  #   typus_user_factory = typus_users(:admin)
  #   options = { email: typus_user_factory.email, role: typus_user_factory.role }
  #   typus_user = TypusUser.generate(options)
  #   assert_equal options[:email], typus_user.email
  #   assert_equal options[:role], typus_user.role
  # end

  test 'should verify authenticated? returns true or false' do
    typus_user = typus_users(:admin)
    assert typus_user.authenticated?('12345678')
    refute typus_user.authenticated?('87654321')
  end

  test 'should verify preferences are nil by default' do
    typus_user = typus_users(:admin)
    assert typus_user.preferences.nil?
  end

  test 'should return default_locale when no preferences are set' do
    typus_user = typus_users(:admin)
    assert typus_user.locale.eql?(:en)
  end

  test 'should be able to set a locale' do
    typus_user = typus_users(:admin)
    typus_user.locale = :jp

    expected = {locale: :jp}
    assert_equal expected, typus_user.preferences
    assert typus_user.locale.eql?(:jp)
  end

  test 'should be able to set preferences' do
    typus_user = typus_users(:admin)
    typus_user.preferences = {chunky: 'bacon'}
    assert typus_user.preferences.present?
  end

  test 'should set locale preference without overriding previously set preferences' do
    typus_user = typus_users(:admin)

    typus_user.preferences = {chunky: 'bacon'}
    typus_user.locale = :jp

    expected = {locale: :jp, chunky: 'bacon'}
    assert_equal expected, typus_user.preferences
  end

  test 'to_label' do
    typus_user = typus_users(:admin)
    assert_equal typus_user.email, typus_user.to_label
  end

  test 'admin gets a list of all applications' do
    typus_user = typus_users(:admin)
    assert_equal Typus.applications, typus_user.applications
  end

  test 'admin gets a list of application resources for Admin application' do
    typus_user = typus_users(:admin)
    expected = %w(AdminUser TypusUser DeviseUser).sort
    assert_equal expected, typus_user.application('Admin').sort
  end

  # TODO: Consider if this test is invalid.
  test 'editor get a list of all applications' do
    typus_user = typus_users(:editor)
    expected = ['Admin', 'CRUD Extended']
    expected.each { |e| assert Typus.applications.include?(e) }
  end

  test 'editor gets a list of application resources' do
    typus_user = typus_users(:editor)
    assert_equal %w(Comment Post), typus_user.application('CRUD Extended')
    assert typus_user.application('Admin').empty?
  end

  test 'user owns a resource' do
    typus_user = typus_users(:admin)
    resource = FactoryGirl.build(:post, typus_user: typus_user)
    assert typus_user.owns?(resource)
  end

  test 'user does not own a resource' do
    typus_user = typus_users(:admin)
    resource = FactoryGirl.create(:post, typus_user: typus_users(:editor))
    refute typus_user.owns?(resource)
  end

  test 'token changes every time we save the user' do
    typus_user = typus_users(:admin)
    first_token = typus_user.token
    typus_user.save
    second_token = typus_user.token
    refute first_token.eql?(second_token)
  end

end
