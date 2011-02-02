require "test_helper"

class ActionsTest < ActiveSupport::TestCase

  include Typus::Actions

  context "add_resource_action" do

    should "work" do
      output = add_resource_action("something")
      expected = [["something"]]

      assert_equal expected, @resource_actions
    end

    should "work when no params are set" do
      add_resource_action()
      assert_equal [], @resource_actions
    end

  end

  context "prepend_resource_action" do

    should "work without args" do
      prepend_resource_action()
      assert_equal [], @resource_actions
    end

    should "work with args" do
      prepend_resource_action("something")
      assert_equal [["something"]], @resource_actions
    end

    should "work prepending an action without args" do
      add_resource_action("something")
      prepend_resource_action()
      assert_equal [["something"]], @resource_actions
    end

    should "work prepending an action with args" do
      add_resource_action("something")
      prepend_resource_action("something_else")
      assert_equal [["something_else"], ["something"]], @resource_actions
    end

  end

  context "append_resource_action" do

    should "work without args" do
      append_resource_action()
      assert_equal [], @resource_actions
    end

    should "work with args" do
      append_resource_action("something")
      assert_equal [["something"]], @resource_actions
    end

    should "work appending an action without args" do
      add_resource_action("something")
      append_resource_action()
      assert_equal [["something"]], @resource_actions
    end

    should "work appending an action with args" do
      add_resource_action("something")
      append_resource_action("something_else")
      assert_equal [["something"], ["something_else"]], @resource_actions
    end

  end

end
