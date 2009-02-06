require 'test/helper'

class ObjectTest < ActiveSupport::TestCase

  def test_should_try_class_method
    assert_equal 'plugin', Post.try('typus')
  end

end