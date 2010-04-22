require "test/test_helper"

class Admin::DashboardHelperTest < ActiveSupport::TestCase

  include Admin::DashboardHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end

=begin

  # FIXME: Pending to verify the applications included. Use the keys.
  def test_applications
    @current_user = typus_users(:admin)

    output = applications
    partial = "admin/helpers/dashboard/applications"
    options = { :applications => { [ "Site", [ "Asset", "Page" ] ] => nil, 
                                   [ "System", [ "Delayed::Task" ] ] => nil, 
                                   [ "Blog", [ "Comment", "Post" ] ] => nil, 
                                   [ "Typus", [ "TypusUser" ] ] => nil } }

    assert_equal partial, output.first
    assert_equal options, output.last
  end

=end

  def test_resources
    @current_user = typus_users(:admin)

    output = resources
    partial = "admin/helpers/dashboard/resources"
    options = { :resources => ["Git", "Status", "WatchDog"] }

    assert_equal partial, output.first
    assert_equal options, output.last
  end

end
