require "test_helper"

class Admin::ListHelperTest < ActiveSupport::TestCase

  include Admin::ListHelper

  context "resources_actions" do

    should "return a default value which is an empty array" do
      assert resources_actions.empty?
    end

    should "return a predefined value" do
      @resources_actions = "mock"
      assert_equal "mock", resources_actions
    end

  end

  context "table_actions" do

    should "be empty" do
      assert list_actions.empty?
    end

    should_eventually "return an array with our custom actions"

  end

end
