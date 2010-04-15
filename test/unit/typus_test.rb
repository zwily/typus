require "test/test_helper"

class TypusTest < ActiveSupport::TestCase

  def test_should_verify_models
    models = [ Asset, Category, Comment, Page, Picture, Post, TypusUser ]
    models.each { |m| assert m.superclass.equal?(ActiveRecord::Base) }
  end

  def test_should_verify_fixtures_are_loaded
    assert_equal 2, Asset.count
    assert_equal 3, Category.count
    assert_equal 4, Comment.count
    assert_equal 6, Page.count
    assert_equal 2, Picture.count
    assert_equal 4, Post.count
    assert_equal 5, TypusUser.count
  end

end
