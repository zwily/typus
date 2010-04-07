require 'test/helper'

class RoutesTest < ActiveSupport::TestCase

  include ActionController::TestCase::Assertions

  def setup
    @routes = ActionController::Routing::Routes.named_routes.routes.keys
  end

  def test_should_verify_admin_dashboard_routes

    expected = [ :admin_dashboard ]
    expected.each { |route| assert @routes.include?(route) }

    assert_routing 'admin/dashboard', :controller => 'admin/dashboard', :action => 'index'

  end

  def test_should_verify_admin_account_named_routes

    expected = [ :admin_sign_up, :admin_sign_in, :admin_sign_out, 
                 :admin_recover_password, :admin_reset_password, 
                 :admin_quick_edit ]
    expected.each { |route| assert @routes.include?(route) }

    actions = [ 'sign_up', 'sign_in', 'sign_out', 
                'recover_password', 'reset_password', 
                'quick_edit' ]

    actions.each { |a| assert_routing "admin/#{a}", :controller => 'admin/account', :action => a }

  end

end
