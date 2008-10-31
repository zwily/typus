require File.dirname(__FILE__) + '/../test_helper'

class TypusTest < Test::Unit::TestCase

  def test_should_verify_enable_exists
    assert Typus.respond_to?('enable')
  end

  def test_should_return_applications_and_should_be_sorted
    assert Typus.respond_to?('applications')
    assert Typus.applications.kind_of?(Array)
    assert_equal ["Blog", "Typus Admin"], Typus.applications
  end

  def test_should_verify_parent_module
    assert Typus.respond_to?('parent_module')
    assert Typus.parent_module(TypusUser.name).kind_of?(String)
    assert_equal "Typus", Typus.parent_module(TypusUser.name)
  end

  def test_should_verify_parent_application
    assert Typus.respond_to?('parent_application')
    assert Typus.parent_application(TypusUser.name).kind_of?(String)
    assert_equal "Typus Admin", Typus.parent_application(TypusUser.name)
  end

  def test_should_return_models_and_should_be_sorted
    assert Typus.respond_to?('models')
    assert Typus.models.kind_of?(Array)
    assert_equal %w( Asset Page Post TypusUser ), Typus.models
  end

  def test_should_verify_modules
    assert Typus.respond_to?('modules')
  end

  def test_should_verify_submodules
    assert Typus.respond_to?('submodules')
  end

  def test_should_verify_version
    assert Typus.respond_to?('version')
  end

end