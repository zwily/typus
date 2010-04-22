require "test/test_helper"

class RoutesTest < ActiveSupport::TestCase

  def setup
    @routes = Rails.application.routes.routes.map(&:name)
  end

  def test_should_verify_admin_routes
    expected = %w(admin)
    expected.each { |r| assert @routes.include?(r) }
  end

  def test_should_verify_admin_dashboard_routes
    expected = %w(admin_dashboard)
    expected.each { |r| assert @routes.include?(r) }
  end

  def test_should_verify_admin_account_named_routes
    expected = %w(forgot_password_admin_account admin_account_index new_admin_account admin_account)
    expected.each { |r| assert @routes.include?(r) }
  end

  def test_should_verify_admin_session_named_routes
    expected = %w(new_admin_session admin_session)
    expected.each { |r| assert @routes.include?(r) }
  end

  def test_should_verift_admin_docs_named_routes
    expected = %w(admin_docs admin_doc)
    expected.each { |r| assert @routes.include?(r) }
  end

end
