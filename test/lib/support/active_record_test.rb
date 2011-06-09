require "test_helper"

class ActiveRecordTest < ActiveSupport::TestCase

  test "relationship between Post and Comment" do
    assert Post.relationship_with(Comment).eql?(:has_many)
  end

  test "relationship between Comment and Post" do
    assert Comment.relationship_with(Post).eql?(:belongs_to)
  end

  test "relationship between Post and Category" do
    assert Post.relationship_with(Category).eql?(:has_and_belongs_to_many)
  end

  test "relationship between Category and Post" do
    assert Category.relationship_with(Post).eql?(:has_and_belongs_to_many)
  end

  test "relationship between Order and Invoice" do
    assert Order.relationship_with(Invoice).eql?(:has_one)
  end

  test "relationship between Invoice and Order" do
    assert Invoice.relationship_with(Order).eql?(:belongs_to)
  end

  test "relationship between Invoice and TypusUser" do
    assert Invoice.relationship_with(TypusUser).eql?(:belongs_to)
  end

  test "relationship between TypusUser and Invoice" do
    assert TypusUser.relationship_with(Invoice).eql?(:has_many)
  end

  context "mapping" do

    context "with an array" do

      setup do
        expected = %w(pending published unpublished)
        Post.stubs(:status).returns(expected)
      end

      should "work for symbols" do
        post = Factory.build(:post)
        assert_equal "published", post.mapping(:status)
      end

      should "work for strings" do
        post = Factory.build(:post, :status => "unpublished")
        assert_equal "unpublished", post.mapping('status')
      end

      should "for unexisting keys returning the current key" do
        post = Factory.build(:post, :status => "unexisting")
        assert_equal "unexisting", post.mapping(:status)
      end

    end

    context "with a two dimension array" do

      setup do
        expected = [["Publicado", "published"],
                    ["Pendiente", "pending"],
                    ["No publicado", "unpublished"]]
        Post.stubs(:status).returns(expected)
      end

      should "verify" do
        post = Factory.build(:post)
        assert_equal "Publicado", post.mapping(:status)
        post = Factory.build(:post, :status => "unpublished")
        assert_equal "No publicado", post.mapping(:status)
      end

    end

    context "with a hash" do

      setup do
        expected = { "Pending - Hash" => "pending",
                     "Published - Hash" => "published",
                     "Not Published - Hash" => "unpublished" }
        Post.stubs(:status).returns(expected)
      end

      should "verify" do
        page = Factory.build(:post)
        assert_equal "Published - Hash", page.mapping(:status)
        page = Factory.build(:post, :status => "unpublished")
        assert_equal "Not Published - Hash", page.mapping(:status)
      end

    end

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
