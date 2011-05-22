require "test_helper"

##
# Here we test:
#
#   include Typus::Orm::ActiveRecord::User::InstanceMethods
#

class UserTest < ActiveSupport::TestCase

  test "to_label" do
    user = Factory.build(:user)
    assert_equal user.email, user.to_label

    user = Factory.build(:user, :first_name => "John")
    assert_equal "John", user.to_label

    user = Factory.build(:user, :last_name => "Locke")
    assert_equal "Locke", user.to_label

    user = Factory.build(:user, :first_name => "John", :last_name => "Locke")
    assert_equal "John Locke", user.to_label
  end

  test "can?" do
    user = Factory.build(:user, :role => 'admin')
    assert user.can?('delete', TypusUser)
    assert !user.cannot?('delete', TypusUser)
    assert user.can?('delete', 'TypusUser')
    assert !user.cannot?('delete', 'TypusUser')
  end

  test "is_root?" do
    user = Factory.build(:user, :role => 'admin')
    assert user.is_root?
    assert !user.is_not_root?
  end

end
