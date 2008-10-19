require File.dirname(__FILE__) + '/../test_helper'

class AdminControllerTest < ActionController::TestCase

  def test_should_get_list_of_roles
    roles = %w( admin editor designer )
    assert_equal roles.sort, Typus::Configuration.roles.map(&:first).sort
  end

  def test_admin_role_settings

    typus_user = typus_users(:admin)
    assert_equal 'admin', typus_user.roles

    models = %w( TypusUser Person Post Comment Category )
    assert_equal models.sort, typus_user.models.map(&:first).sort

    models.each { |model| assert typus_user.can_create? model }
    models.each { |model| assert typus_user.can_read? model }
    models.each { |model| assert typus_user.can_update? model }
    models.each { |model| assert typus_user.can_destroy? model }

  end

  def test_editor_role_settings

    typus_user = typus_users(:editor)
    assert_equal 'editor', typus_user.roles

    models = %w( Category Comment Post TypusUser )
    assert_equal models.sort, typus_user.models.map(&:first).sort

    assert typus_user.can_create? Category
    assert !typus_user.can_create?(Comment)
    assert typus_user.can_create? Post
    assert !typus_user.can_create?(TypusUser)

    assert !typus_user.can_read?(Category)
    assert !typus_user.can_read?(Comment)
    assert !typus_user.can_read?(Post)
    assert !typus_user.can_read?(TypusUser)

    assert typus_user.can_update? Category
    assert typus_user.can_update? Comment
    assert typus_user.can_update? Post
    assert typus_user.can_update? TypusUser

    assert !typus_user.can_destroy?(Category)
    assert typus_user.can_destroy? Comment
    assert !typus_user.can_destroy?(Post)
    assert !typus_user.can_destroy?(TypusUser)

  end

  def test_designer_role_settings

    typus_user = typus_users(:designer)
    assert_equal 'designer', typus_user.roles

    models = %w( Category Post )
    assert_equal models.sort, typus_user.models.map(&:first).sort

    assert !typus_user.can_create?(Post)

    assert typus_user.can_read? Category
    assert typus_user.can_read? Post

    assert typus_user.can_update? Category
    assert !typus_user.can_update?(Post)

  end

  def test_configuration_options
    assert_equal "Typus", Typus::Configuration.options[:app_name]
    assert_equal "", Typus::Configuration.options[:app_description]
    assert_equal 15, Typus::Configuration.options[:per_page]
    assert_equal 10, Typus::Configuration.options[:form_rows]
    assert_equal 10, Typus::Configuration.options[:form_columns]
    assert_equal 5, Typus::Configuration.options[:minute_step]
    assert_equal true, Typus::Configuration.options[:toggle]
    assert_equal true, Typus::Configuration.options[:edit_after_create]
    assert_equal 'admin@example.com', Typus::Configuration.options[:email]
    assert_equal 8, Typus::Configuration.options[:password]
  end

end