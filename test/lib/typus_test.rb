require "test_helper"

class TypusTest < ActiveSupport::TestCase

  should "verify default_config for autocomplete" do
    assert Typus.autocomplete.nil?
  end

  should "verify default_config for admin_title" do
    assert Typus.admin_title.eql?('Typus')
  end

  should "verify default_config for admin_sub_title" do
    assert Typus.admin_sub_title.is_a?(String)
  end

  should "verify default_config for authentication" do
    assert Typus.authentication.eql?(:session)
  end

  should "verify default_config for mailer_sender" do
    assert Typus.mailer_sender.nil?
  end

  should "verify default_config for username" do
    assert Typus.username.eql?('admin')
  end

  should "verify default_config for password" do
    assert Typus.password.eql?('columbia')
  end

  context "file management" do

    context "paperclip" do

      should "verify default_config for file_preview" do
        assert Typus.file_preview.eql?(:medium)
      end

      should "verify default_config for file_thumbnail" do
        assert Typus.file_thumbnail.eql?(:thumb)
      end

    end

    context "dragonfly" do

      should "verify default_config for image_preview_size" do
        assert_equal "x650>", Typus.image_preview_size
      end

      should "verify default_config for image_thumb_size" do
        assert_equal "x100", Typus.image_thumb_size
      end

    end

  end

  should "verify default_config for relationship" do
    assert Typus.relationship.eql?('typus_users')
  end

  should "verify default_config for master_role" do
    assert Typus.master_role.eql?('admin')
  end

  should "verify config_folder is a Pathname" do
    assert Typus.config_folder.is_a?(Pathname)
  end

  should "return applications sorted" do
    expected = ["Admin", "CRUD", "CRUD Extended", "CRUD Namespaced", "HasManyThrough", "HasOne", "MongoDB", "Polymorphic", "STI"]
    assert_equal expected, Typus.applications
  end

  should "return modules of the CRUD Extended application" do
    expected = %w(Asset Category Comment Page Post)
    assert Typus.application("CRUD Extended").eql?(expected)
  end

  should "return models and should be sorted" do
    expected = ["AdminUser",
                "Animal",
                "Article::Entry",
                "Asset",
                "Bird",
                "Case",
                "Category",
                "Comment",
                "Dog",
                "Entry",
                "Hit",
                "ImageHolder",
                "Invoice",
                "Order",
                "Page",
                "Post",
                "Project",
                "ProjectCollaborator",
                "TypusUser",
                "User",
                "View"]
    assert_equal expected, Typus.models
  end

  should "verify resources class_method" do
    assert_equal %w(Git Status WatchDog), Typus.resources
  end

  test "user_class returns default value" do
    Typus::Configuration.models_constantized!
    assert_equal TypusUser, Typus.user_class
  end

  test "user_class_name returns default value" do
    assert Typus.user_class_name.eql?("TypusUser")
  end

  test "user_class_name setter presence" do
    assert Typus.respond_to?("user_class_name=")
  end

  test "user_fk returns default value" do
    assert Typus.user_fk.eql?("typus_user_id")
  end

  test "user_fk setter presence" do
    assert Typus.respond_to?("user_fk=")
  end

end
