require "test_helper"

class TypusUserRolesTest < ActiveSupport::TestCase

  test "configuration roles" do
    assert_equal %w(admin designer editor), Typus::Configuration.roles.map(&:first).sort
  end

  test 'admin role' do
    typus_user = typus_users(:admin)

    config = {
      'View' => {},
      'AdminUser' => {},
      'Category' => {},
    }

    typus_user.stubs(:resources).returns(config)

    expected = %w(AdminUser Category View)
    assert_equal expected, typus_user.resources.map(&:first).sort
  end

  test 'admin role has access to all actions on models' do
    typus_user = typus_users(:admin)
    models = %w(Asset Category Comment Page Post TypusUser View)
    %w(create read update destroy).each { |a| models.each { |m| assert typus_user.can?(a, m) } }
  end

  test 'admin role can perform action on resource' do
    typus_user = typus_users(:admin)
    assert typus_user.can?('index', 'Status', { special: true })
  end

  test 'admin role cannot perform action on resource' do
    typus_user = typus_users(:admin)
    assert typus_user.cannot?('show', 'Status', { special: true })
  end

  test 'admin role cannot perform actions on resources which do not have that action defined' do
    typus_user = typus_users(:admin)
    assert typus_user.cannot?('destroy', 'Order')
  end

  test 'editor role' do
    typus_user = typus_users(:editor)

    expected = %w(Comment Git Post View)
    assert_equal expected, typus_user.resources.map(&:first).sort

    %w(create read update).each { |a| assert typus_user.can?(a, 'Post') }
    %w(delete).each { |a| assert typus_user.cannot?(a, 'Post') }

    %w(read update delete).each { |a| assert typus_user.can?(a, 'Comment') }
    %w(create).each { |a| assert typus_user.cannot?(a, 'Comment') }

    %w().each { |a| assert typus_user.can?(a, 'TypusUser') }
    %w().each { |a| assert typus_user.cannot?(a, 'TypusUser') }
  end

  test 'designer role' do
    typus_user = typus_users(:designer)

    expected = %w(Comment Post)
    assert_equal expected, typus_user.resources.map(&:first).sort

    %w(read).each { |a| assert typus_user.can?(a, 'Comment') }
    %w(create update delete).each { |a| assert typus_user.cannot?(a, 'Comment') }

    %w(read update).each { |a| assert typus_user.can?(a, 'Post') }
    %w(create delete).each { |a| assert typus_user.cannot?(a, 'Post') }
  end

end
