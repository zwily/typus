require "test_helper"

class StringTest < ActiveSupport::TestCase

  should "extract_settings" do
    assert_equal %w( a b c ), "a, b, c".extract_settings
    assert_equal %w( a b c ), " a  , b,  c ".extract_settings
  end

  should "remove prefix" do
    assert_equal "posts", "admin/posts".remove_prefix
    assert_equal "typus_users", "admin/typus_users".remove_prefix
    assert_equal "delayed/jobs", "admin/delayed/jobs".remove_prefix
  end

  should "remove prefix with params" do
    assert_equal "posts", "typus/posts".remove_prefix("typus/")
    assert_equal "typus_users", "typus/typus_users".remove_prefix("typus/")
    assert_equal "delayed/tasks", "typus/delayed/tasks".remove_prefix("typus/")
  end

  should "extract_class" do
    assert_equal Post, "admin/posts".extract_class
    assert_equal TypusUser, "admin/typus_users".extract_class
    assert_equal Delayed::Task, "admin/delayed/tasks".extract_class
  end

end
