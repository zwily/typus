require File.dirname(__FILE__) + '/../test_helper'

class TypusTest < Test::Unit::TestCase

  def test_should_return_applications_and_should_be_sorted
    assert Typus.respond_to?(:applications)
    assert Typus.applications.kind_of?(Array)
    assert_equal ["Blog", "Site", "Typus Admin"], Typus.applications
  end

  def test_should_return_modules_of_an_application
    assert Typus.respond_to?(:application)
    assert_equal ["Post"], Typus.application('Blog')
  end

  def test_should_return_modules_of_a_module
    assert Typus.respond_to?(:module)
    assert_equal ["Category"], Typus.module("Post")
  end

  def test_should_verify_parent_module
    assert Typus.respond_to?(:parent_module)
    assert Typus.parent_module(TypusUser.name).kind_of?(String)
    assert_equal "Typus", Typus.parent_module(TypusUser.name)
  end

  def test_should_verify_parent_application
    assert Typus.respond_to?(:parent_application)
    assert Typus.parent_application(TypusUser.name).kind_of?(String)
    assert_equal "Typus Admin", Typus.parent_application(TypusUser.name)
  end

  def test_should_return_models_and_should_be_sorted
    assert Typus.respond_to?(:models)
    assert Typus.models.kind_of?(Array)
    assert_equal %w( Asset Category Page Post TypusUser ), Typus.models
  end

  def test_should_verify_resources_class_method
    assert Typus.respond_to?(:resources)
    assert_equal ["Status"], Typus.resources
  end

  def test_should_return_description_of_module
    assert Typus.respond_to?(:module_description)
    assert_equal "System Users Administration", Typus.module_description('TypusUser')
  end

  def test_should_verify_version
    assert Typus.respond_to?(:version)
  end

  def test_should_verify_enable_exists
    assert Typus.respond_to?(:enable)
  end

end