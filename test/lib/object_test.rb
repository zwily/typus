require File.dirname(__FILE__) + '/../test_helper'

class ObjectTest < Test::Unit::TestCase

  def test_should_try_class_method
    assert_equal 'plugin', Post.try('typus')
  end

end