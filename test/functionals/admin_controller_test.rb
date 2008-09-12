require File.dirname(__FILE__) + '/../test_helper'

class AdminControllerTest < ActionController::TestCase

  def test_admin_role_settings

    typus_user = typus_users(:admin)

    models = %w( TypusUser Person Post Comment Category )
    assert_equal typus_user.models.map(&:first).sort, models.sort

    models.each { |model| assert typus_user.can_create? model }
    models.each { |model| assert typus_user.can_read? model }
    models.each { |model| assert typus_user.can_update? model }
    models.each { |model| assert typus_user.can_destroy? model }

  end

  def test_editor_role_settings

    typus_user = typus_users(:editor)

    models = %w( Category Comment Post TypusUser )
    assert_equal typus_user.models.map(&:first).sort, models.sort

    assert typus_user.can_create? Category
    assert typus_user.can_create? Post

    assert typus_user.can_update? Category
    assert typus_user.can_update? Post
    assert typus_user.can_update? Comment
    assert typus_user.can_update? TypusUser

    assert typus_user.can_destroy? Comment

  end

  def test_designer_role_settings

    typus_user = typus_users(:designer)

    models = %w( Category Post )
    assert_equal typus_user.models.map(&:first).sort, models.sort

    assert typus_user.can_create? Post

    assert typus_user.can_read? Category
    assert typus_user.can_read? Post

    assert typus_user.can_update? Category
    assert typus_user.can_update? Post

  end

  def test_should_get_list_of_roles

    roles = %w( admin editor designer )
    assert_equal Typus::Configuration.roles.map(&:first).sort, roles.sort

  end

  def test_configuration_options
    assert_equal "Typus Admin", Typus::Configuration.options[:app_name]
    assert_equal "", Typus::Configuration.options[:app_description]
    assert_equal 15, Typus::Configuration.options[:per_page]
    assert_equal '10', Typus::Configuration.options[:form_rows]
    assert_equal '10', Typus::Configuration.options[:form_columns]
    assert_equal true, Typus::Configuration.options[:toggle]
    assert_equal true, Typus::Configuration.options[:edit_after_create]
  end

end