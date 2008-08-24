require File.dirname(__FILE__) + '/../test_helper'

class StringTest < Test::Unit::TestCase

  def test_modelize
    assert_equal "people".modelize, Person
    assert_equal "categories".modelize, Category
    assert_equal "typus_users".modelize, TypusUser
  end

  def test_to_class
    assert_equal "people".to_class, Person
    assert_equal "categories".to_class, Category
    assert_equal "typus_users".to_class, TypusUser
  end

end