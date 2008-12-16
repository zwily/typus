require File.dirname(__FILE__) + '/../test_helper'

class TypusTest < Test::Unit::TestCase

  def test_should_return_applications_and_should_be_sorted
    assert Typus.respond_to?(:applications)
    assert Typus.applications.kind_of?(Array)
    assert_equal ["Application", "Blog", "Site", "Typus Admin"], Typus.applications
  end

  def test_should_return_modules_of_an_application
    assert Typus.respond_to?(:application)
    assert_equal ["Comment", "Post"], Typus.application('Blog')
  end

  def test_should_return_modules_of_a_module
    assert Typus.respond_to?(:module)
    assert_equal ["Category"], Typus.module("Post")
  end

  def test_should_verify_parent_exists
    assert Typus.respond_to?(:parent)
  end

  def test_should_verify_parent_for_module
    assert Typus.parent(TypusUser.name, 'module').kind_of?(String)
    assert_equal "Typus", Typus.parent(TypusUser.name, 'module')
  end

  def test_should_verify_parent_for_application
    assert Typus.parent(TypusUser.name, 'application').kind_of?(String)
    assert_equal "Typus Admin", Typus.parent(TypusUser.name, 'application')
  end

  def test_should_verify_parent_for_nothing
    assert Typus.parent(TypusUser.name, 'nothing').kind_of?(String)
    assert_equal '', Typus.parent(TypusUser.name, 'nothing')
  end

  def test_should_return_models_and_should_be_sorted
    assert Typus.respond_to?(:models)
    assert Typus.models.kind_of?(Array)
    assert_equal %w( Asset Category Comment Page Person Post TypusUser ), Typus.models
  end

  def test_should_verify_resources_class_method
    assert Typus.respond_to?(:resources)
    assert_equal ["Status"], Typus.resources
  end

  def test_should_return_description_of_module
    assert Typus.respond_to?(:module_description)
    assert_equal "System Users Administration", Typus.module_description('TypusUser')
  end

  def test_should_verify_enable_exists
    assert Typus.respond_to?(:enable)
  end

  def test_should_verify_enable_exists
    assert Typus.respond_to?(:generator)
  end

end