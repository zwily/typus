require File.dirname(__FILE__) + '/../test_helper'

class StringTest < Test::Unit::TestCase

  def test_should_verify_modelize
    assert_equal Person, "people".modelize
    assert_equal Category, "categories".modelize
    assert_equal TypusUser, "typus_users".modelize
  end

  def test_should_verify_to_class
    assert_equal Person, "people".to_class
    assert_equal Category, "categories".to_class
    assert_equal TypusUser, "typus_users".to_class
  end

end