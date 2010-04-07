require 'test/helper'

class Admin::DashboardHelperTest < ActiveSupport::TestCase

  include Admin::DashboardHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper
  include ActionController::UrlWriter

  def render(*args); args; end

  def test_applications

    @current_user = typus_users(:admin)

    output = applications

    partial = "admin/helpers/applications"
    options = { :applications => { [ "Blog", [ "Comment", "Post" ] ]=> nil, 
                                   [ "Site", [ "Asset", "Page" ] ] => nil, 
                                   [ "System", [ "Delayed::Task" ] ] => nil, 
                                   [ "Typus", [ "TypusUser" ] ] => nil } }

    assert_equal partial, output.first
    # FIXME: Pending to verify the applications included. Use the keys.
    # assert_equal options, output.last

  end

  def test_resources

    @current_user = typus_users(:admin)

    output = resources
    partial = "admin/helpers/resources"
    options = { :resources => ["Git", "Status", "WatchDog"] }

    assert_equal partial, output.first
    assert_equal options, output.last

  end

end