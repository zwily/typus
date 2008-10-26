require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase

  def test_should_check_attributes
    assert Post.respond_to?("typus")
    assert_equal "plugin", Post.typus
  end

end