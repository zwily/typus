require 'test/helper'

class RoutesTest < ActiveSupport::TestCase

  include ActionController::TestCase::Assertions

  def setup
    @routes = Rails.application.routes.routes.map(&:name)
  end

  def test_should_verify_admin_dashboard_routes

    expected = %w( admin_dashboard )
    expected.each { |r| assert @routes.include?(r.to_sym) }

    assert_routing "admin/dashboard", :controller => "admin/dashboard", :action => "index"

  end

  def test_should_verify_admin_account_named_routes

    expected = %w( admin_sign_up admin_sign_in admin_sign_out 
                   admin_recover_password admin_reset_password )
    expected.each { |r| assert @routes.include?(r.to_sym) }

    actions = %w( sign_up sign_in sign_out recover_password reset_password )

    actions.each { |a| assert_routing "admin/#{a}", :controller => "admin/account", :action => a }

  end

end
