require File.dirname(__FILE__) + '/../test_helper'

class AdminControllerTest < ActionController::TestCase

  def test_should_get_list_of_roles
    roles = %w( admin editor designer )
    assert_equal roles.sort, Typus::Configuration.roles.map(&:first).sort
  end

  def test_admin_role_settings

    typus_user = typus_users(:admin)
    assert_equal 'admin', typus_user.roles

    models = %w( TypusUser Person Post Comment Category Page Asset )
    assert_equal models.sort, typus_user.models.map(&:first).sort

    %w( create read update destroy ).each do |action|
      models.each { |model| assert typus_user.can_perform?(model, action) }
    end

  end

  def test_editor_role_settings

    typus_user = typus_users(:editor)
    assert_equal 'editor', typus_user.roles

    models = %w( Category Comment Post TypusUser )
    assert_equal models.sort, typus_user.models.map(&:first).sort

    ##
    # Category: create, update
    #
    assert typus_user.can_perform?(Category, 'create')
    assert !typus_user.can_perform?(Category, 'read')
    assert typus_user.can_perform?(Category, 'update')
    assert !typus_user.can_perform?(Category, 'delete')

    ##
    # Post: create, update
    #
    assert typus_user.can_perform?(Post, 'create')
    assert !typus_user.can_perform?(Post, 'read')
    assert typus_user.can_perform?(Post, 'update')
    assert !typus_user.can_perform?(Post, 'delete')

    ##
    # Comment: update, delete
    #
    assert !typus_user.can_perform?(Comment, 'create')
    assert !typus_user.can_perform?(Comment, 'read')
    assert typus_user.can_perform?(Comment, 'update')
    assert typus_user.can_perform?(Comment, 'delete')

    ##
    # TypusUser: update
    #
    assert !typus_user.can_perform?(TypusUser, 'create')
    assert !typus_user.can_perform?(TypusUser, 'read')
    assert typus_user.can_perform?(TypusUser, 'update')
    assert !typus_user.can_perform?(TypusUser, 'delete')

  end

  def test_designer_role_settings

    typus_user = typus_users(:designer)
    assert_equal 'designer', typus_user.roles

    models = %w( Category Post )
    assert_equal models.sort, typus_user.models.map(&:first).sort

    ##
    #  Category: read, update
    #
    assert !typus_user.can_perform?(Category, 'create')
    assert typus_user.can_perform?(Category, 'read')
    assert typus_user.can_perform?(Category, 'update')
    assert !typus_user.can_perform?(Category, 'delete')

    ##
    #  Post: read
    #
    assert !typus_user.can_perform?(Post, 'create')
    assert typus_user.can_perform?(Post, 'read')
    assert !typus_user.can_perform?(Post, 'update')
    assert !typus_user.can_perform?(Post, 'delete')

  end

end