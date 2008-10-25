require File.dirname(__FILE__) + '/../test_helper'

class TypusTest < Test::Unit::TestCase

  def test_should_verify_comment_model_exists
    assert Comment.kind_of?(Class)
  end

  def test_should_verify_page_model_exists
    assert Page.kind_of?(Class)
  end

  def test_should_verify_tag_model_exists
    assert Tag.kind_of?(Class)
  end

  def test_should_verify_category_model_exists
    assert Category.kind_of?(Class)
  end

  def test_shoud_verify_post_model_exists
    assert Post.kind_of?(Class)
  end

  def test_shoud_verify_person_model_exists
    assert Person.kind_of?(Class)
  end

  def test_should_verify_fixtures_are_loaded
    assert_equal 3, Category.count
    assert_equal 2, Post.count
    assert_equal 4, Tag.count
    assert_equal 5, TypusUser.count
  end

  def test_should_verify_typus_responds_to_some_questions
    assert Typus.respond_to?('version')
    assert Typus.respond_to?('applications')
    assert Typus.respond_to?('models')
    assert Typus.respond_to?('modules')
  end

end