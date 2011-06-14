require "test_helper"

=begin

  Here we test:

  - Typus::Orm::ActiveRecord::AdminUserV2

=end

class AdminUserTest < ActiveSupport::TestCase

  test "token changes everytime we save the user" do
    admin_user = Factory(:admin_user)
    first_token = admin_user.token
    admin_user.save
    second_token = admin_user.token
    assert !first_token.eql?(second_token)
  end

  test "mass_assignment" do
    assert TypusUser.attr_protected[:default].include?(:status)
  end

end
