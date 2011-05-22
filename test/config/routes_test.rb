require "test_helper"

class RoutesTest < ActiveSupport::TestCase

  setup do
    @routes = Admin::Engine.routes.routes.map(&:name)
  end

  should "have root" do
    expected = %w(root)
    expected.each { |r| assert @routes.include?(r) }
  end

  should "have account routes" do
    expected = %w(forgot_password_account_index account_index new_account account)
    expected.each { |r| assert @routes.include?(r) }
  end

  should "have session routes" do
    expected = %w(new_session session)
    expected.each { |r| assert @routes.include?(r) }
  end

end
