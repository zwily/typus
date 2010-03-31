require 'test/helper'

class Admin::DashboardHelperTest < ActiveSupport::TestCase

  include Admin::DashboardHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper
  include ActionController::UrlWriter

  def render(*args); args; end

  # FIXME: Pending to verify the applications included. Use the keys.
  def test_applications

    @current_user = typus_users(:admin)

    output = applications

    partial = "admin/helpers/applications"
    options = { :applications => { [ "Blog", [ "Comment", "Post" ] ]=> nil, 
                                   [ "Site", [ "Asset", "Page" ] ] => nil, 
                                   [ "System", [ "Delayed::Task" ] ] => nil, 
                                   [ "Typus", [ "TypusUser" ] ] => nil } }

    assert_equal partial, output.first
    # assert_equal options, output.last

  end

  # FIXME: Pending to add the options.
  def test_resources

    @current_user = typus_users(:admin)

    output = resources
    partial = "admin/helpers/resources"
    options = {}

    assert_equal partial, output.first
    # assert_equal options, output.last

  end

end