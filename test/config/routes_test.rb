require "test_helper"

class RoutesTest < ActiveSupport::TestCase

  setup do
    # @routes = Admin::Engine.routes.routes.map(&:name)
    @routes = Rails.application.routes.routes.map(&:name)
  end

  should "have dashboard routes" do
    expected = %w(admin_dashboard)
    expected.each { |r| assert @routes.include?(r) }
  end

  should "have account routes" do
    expected = %w(forgot_password_admin_account_index
                  send_password_admin_account_index
                  admin_account_index
                  new_admin_account
                  admin_account)

    expected.each { |r| assert @routes.include?(r) }
  end

  should "have session routes" do
    expected = %w(new_admin_session admin_session)
    expected.each { |r| assert @routes.include?(r) }
  end

end
