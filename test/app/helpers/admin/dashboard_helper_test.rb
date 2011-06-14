require "test_helper"

class Admin::DashboardHelperTest < ActiveSupport::TestCase

  include Admin::DashboardHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end

  setup do
    @expected = ["helpers/admin/resources/dashboard/resources", { :resources => ["Git", "Status", "WatchDog"] }]
  end

  test "resources work for typus_user" do
    admin_user = Factory(:typus_user)
    output = resources(admin_user)
    assert_equal @expected, output
  end

  test "resources work for fake_user" do
    admin_user = FakeUser.new
    output = resources(admin_user)
    assert_equal @expected, output
  end

end
