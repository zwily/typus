require "test/test_helper"

class TypusTest < ActiveSupport::TestCase

  def test_should_verify_models
    models = [ Asset, Category, Comment, Page, Picture, Post, TypusUser ]
    models.each { |m| assert m.superclass.equal?(ActiveRecord::Base) }
  end

end
