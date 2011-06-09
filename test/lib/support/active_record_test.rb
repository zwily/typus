require "test_helper"

class ActiveRecordTest < ActiveSupport::TestCase

  test "relationship between models" do
    assert Category.relationship_with(Post).eql?(:has_and_belongs_to_many)
    assert Comment.relationship_with(Post).eql?(:belongs_to)
    assert Invoice.relationship_with(Order).eql?(:belongs_to)
    assert Invoice.relationship_with(TypusUser).eql?(:belongs_to)
    assert Order.relationship_with(Invoice).eql?(:has_one)
    assert Post.relationship_with(Category).eql?(:has_and_belongs_to_many)
    assert Post.relationship_with(Comment).eql?(:has_many)
    assert TypusUser.relationship_with(Invoice).eql?(:has_many)
  end

  test "mapping with an array" do
    expected = %w(pending published unpublished)
    Post.stubs(:status).returns(expected)

    post = Factory.build(:post)
    assert_equal "published", post.mapping(:status)

    post = Factory.build(:post, :status => "unpublished")
    assert_equal "unpublished", post.mapping('status')

    post = Factory.build(:post, :status => "unexisting")
    assert_equal "unexisting", post.mapping(:status)
  end

  test "mapping with a two dimension array" do
    expected = [["Publicado", "published"], ["Pendiente", "pending"], ["No publicado", "unpublished"]]
    Post.stubs(:status).returns(expected)

    post = Factory.build(:post)
    assert_equal "Publicado", post.mapping(:status)

    post = Factory.build(:post, :status => "unpublished")
    assert_equal "No publicado", post.mapping(:status)
  end

  test "mapping with a hash" do
    expected = { "Pending - Hash" => "pending", "Published - Hash" => "published", "Not Published - Hash" => "unpublished" }
    Post.stubs(:status).returns(expected)

    page = Factory.build(:post)
    assert_equal "Published - Hash", page.mapping(:status)
    page = Factory.build(:post, :status => "unpublished")
    assert_equal "Not Published - Hash", page.mapping(:status)
  end

  context "to_label" do

    should "return email for TypusUser" do
      typus_user = Factory.build(:typus_user)
      assert_equal typus_user.email, typus_user.to_label
    end

    should "return name for Category" do
      category = Factory.build(:category, :name => "Chunky Bacon")
      assert_match "Chunky Bacon", category.to_label
    end

    should "return Model#id because Category#name is empty" do
      category = Factory(:category)
      category.name = nil
      category.save(:validate => false)
      assert_equal "Category##{category.id}", category.to_label
    end

    should "return default Model#id" do
      assert_match /Post#/, Factory(:post).to_label
    end

  end

  test "to_resource" do
    assert_equal "typus_users", TypusUser.to_resource
    assert_equal "delayed/tasks", Delayed::Task.to_resource
  end

end
