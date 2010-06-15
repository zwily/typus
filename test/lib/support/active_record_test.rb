require "test/test_helper"

class ActiveRecordTest < ActiveSupport::TestCase

  # Remove all fixtures ... this is to make it compatible with the old 
  # tests. Will remove it once everything is refactored with Shoulda and 
  # FactoryGirl.
  setup do
    TypusUser.delete_all
  end

  should "verify mapping instace method with an array" do
    post = posts(:published)
    assert_equal "published", post.mapping(:status)
    post = posts(:unpublished)
    assert_equal "unpublished", post.mapping(:status)
  end

  should "verify mapping instace method with a hash" do
    page = Factory(:page)
    assert_equal "Published", page.mapping(:status)
    page = Factory(:page, :status => "unpublished")
    assert_equal "Not Published", page.mapping(:status)
  end

  should "verify to_label instace method" do
    typus_user = Factory(:typus_user)
    assert_equal "admin@example.com", typus_user.to_label
    assert_equal "Post#1", posts(:published).to_label
  end

  should "verify to_resource instance method" do
    assert_equal "typus_users", TypusUser.to_resource
    assert_equal "delayed/tasks", Delayed::Task.to_resource
  end

end
