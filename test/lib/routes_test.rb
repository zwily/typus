require File.dirname(__FILE__) + '/../test_helper'

class RoutesTest < Test::Unit::TestCase

  def test_should_verify_typus_named_routes

    routes = ActionController::Routing::Routes.named_routes.routes.keys

    expected = [ :typus_setup, 
                 :typus_login, :typus_logout, 
                 :typus_recover_password, :typus_reset_password, 
                 :typus_dashboard ]

    expected.each { |route| assert routes.include?(route) }

  end

  def test_should_verify_typus_generated_routes
    %w( login logout setup recover_password reset_password ).each do |route|
      assert_generates "admin/#{route}", { :controller => 'typus', :action => route }
    end
  end

  def test_should_verify_admin_routes_for_a_typus_user

    routes = ActionController::Routing::Routes.named_routes.routes.keys

    expected = [ :admin_typus_users, 
                 :admin_typus_user, 
                 :position_admin_typus_user, 
                 :toggle_admin_typus_user, 
                 :relate_admin_typus_user,
                 :unrelate_admin_typus_user ]

    expected.each { |route| assert routes.include?(route) }

  end

  def test_should_verify_admin_routes_for_a_post

    routes = ActionController::Routing::Routes.named_routes.routes.keys

    expected = [ :admin_posts, 
                 :admin_post, 
                 :position_admin_post, 
                 :toggle_admin_post, 
                 :relate_admin_post,
                 :unrelate_admin_post, 
                 :cleanup_admin_posts, 
                 :send_as_newsletter_admin_post, 
                 :preview_admin_post ]

    expected.each { |route| assert routes.include?(route) }

  end

end