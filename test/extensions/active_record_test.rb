require "test/test_helper"

class ActiveRecordTest < ActiveSupport::TestCase

  def test_mapping_with_an_array
    post = posts(:published)
    assert_equal "published", post.mapping(:status)
    post = posts(:unpublished)
    assert_equal "unpublished", post.mapping(:status)
  end

  def test_mapping_with_a_hash
    page = pages(:published)
    assert_equal "Published", page.mapping(:status)
    page = pages(:unpublished)
    assert_equal "Not Published", page.mapping(:status)
  end

  def test_to_label
    assert typus_users(:admin).respond_to?(:to_label)
  end

  def test_to_label_when_model_has_name
    assert_equal "Admin Example", typus_users(:admin).to_label
  end

  def test_to_label_when_model_has_no_name_attribute
    assert_equal "Post#1", posts(:published).to_label
  end

  def test_to_resource
    assert_equal "typus_users", TypusUser.to_resource
    assert_equal "delayed/tasks", Delayed::Task.to_resource
  end

end
