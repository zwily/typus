require 'test/helper'

class RoutesTest < ActiveSupport::TestCase

  include ActionController::TestCase::Assertions
  include ActionController::Assertions::RoutingAssertions

  def test_should_verify_admin_named_routes

    routes = ActionController::Routing::Routes.named_routes.routes.keys

    expected = [ :admin_sign_up, :admin_sign_in, :admin_sign_out, 
                 :admin_recover_password, :admin_reset_password, 
                 :admin_dashboard, :admin_overview, 
                 :admin_quick_edit, :admin_set_locale ]

    expected.each { |route| assert routes.include?(route) }

  end

  def test_should_verify_admin_routes_for_typus_users

    routes = ActionController::Routing::Routes.named_routes.routes.keys

    expected = [ :admin_typus_users, 
                 :admin_typus_user, 
                 :position_admin_typus_user, 
                 :toggle_admin_typus_user ]

    expected.each { |route| assert routes.include?(route) }

    expected = [ :relate_admin_typus_user,
                 :unrelate_admin_typus_user ]

    expected.each { |route| assert !routes.include?(route) }

  end

  def test_should_verify_default_admin_routes_for_posts

    routes = ActionController::Routing::Routes.named_routes.routes.keys

    expected = [ :admin_posts, 
                 :admin_post, 
                 :position_admin_post, 
                 :toggle_admin_post, 
                 :relate_admin_post,
                 :unrelate_admin_post ]

    expected.each { |route| assert routes.include?(route) }

  end

  def test_should_verify_custom_admin_routes_for_posts

    routes = ActionController::Routing::Routes.named_routes.routes.keys

    expected = [ :cleanup_admin_posts, 
                 :send_as_newsletter_admin_post, 
                 :preview_admin_post ]

    expected.each { |route| assert routes.include?(route) }

  end

  def test_should_verify_routes_for_resource
    assert_routing '/typus/watch_dog', :controller => 'admin/watch_dog', :action => 'index'
    assert_routing '/typus/watch_dog/cleanup', { :controller => 'admin/watch_dog', :action => 'cleanup' }
  end

end