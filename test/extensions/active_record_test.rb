require "test/helper"

class ActiveRecordTest < ActiveSupport::TestCase

  def setup
    @typus_user = typus_users(:admin)
  end

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
    assert @typus_user.respond_to?(:to_label)
  end

  def test_to_label_when_model_has_name
    @typus_user.stubs(:name).returns("name")
    assert_equal "name", @typus_user.to_label
  end

  def test_to_label_when_model_has_no_name_attribute
    assert_equal "TypusUser#1", @typus_user.to_label
  end

end
