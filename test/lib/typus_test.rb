require "test_helper"

class TypusTest < ActiveSupport::TestCase

  test "default_config for autocomplete" do
    assert Typus.autocomplete.nil?
  end

  test "default_config for admin_title" do
    assert Typus.admin_title.eql?('Typus')
  end

  test "default_config for admin_sub_title" do
    assert Typus.admin_sub_title.is_a?(String)
  end

  test "default_config for authentication" do
    assert Typus.authentication.eql?(:session)
  end

  test "default_config for mailer_sender" do
    assert Typus.mailer_sender.nil?
  end

  test "default_config for username" do
    assert Typus.username.eql?('admin')
  end

  test "default_config for password" do
    assert Typus.password.eql?('columbia')
  end

  test "default_config for file_preview and file_thumbnail (paperclip)" do
    assert Typus.file_preview.eql?(:medium)
    assert Typus.file_thumbnail.eql?(:thumb)
  end

  test "default_config for image_preview_size and image_thumb_size (dragonfly)" do
    assert_equal "x650>", Typus.image_preview_size
    assert_equal "x100", Typus.image_thumb_size
  end

  test "default_config for relationship" do
    assert Typus.relationship.eql?('typus_users')
  end

  test "default_config for master_role" do
    assert Typus.master_role.eql?('admin')
  end

  test "config_folder is a Pathname" do
    assert Typus.config_folder.is_a?(Pathname)
  end

  test "applications returns applications sorted" do
    expected = ["Admin", "CRUD", "CRUD Extended", "Extensions", "HasManyThrough", "HasOne", "MongoDB", "Polymorphic"]
    assert_equal expected, Typus.applications
  end

  test "application returns modules of the CRUD Extended application" do
    expected = %w(Asset Case Comment Page Post Article::Entry)
    assert_equal expected, Typus.application("CRUD Extended")
  end

  test "models are sorted" do
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
                "EntryBulk",
                "EntryTrash",
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

  test "resources class_method" do
    assert_equal %w(Git Status WatchDog), Typus.resources
  end

=begin
  test "user_class returns default value" do
    Typus::Configuration.models_constantized!
    assert_equal TypusUser, Typus.user_class
  end
=end

  test "user_class_name returns default value" do
    assert Typus.user_class_name.eql?("TypusUser")
  end

  test "user_class_name setter presence" do
    assert Typus.respond_to?("user_class_name=")
  end

  test "user_foreign_key returns default value" do
    assert Typus.user_foreign_key.eql?("typus_user_id")
  end

  test "user_foreign_key setter presence" do
    assert Typus.respond_to?("user_foreign_key=")
  end

end
