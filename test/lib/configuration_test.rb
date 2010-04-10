require "test/helper"

class ConfigurationTest < ActiveSupport::TestCase

  def test_should_verify_typus_roles_is_loaded
    assert Typus::Configuration.respond_to?(:roles!)
    assert Typus::Configuration.roles!.kind_of?(Hash)
  end

  def test_should_verify_typus_config_file_is_loaded
    assert Typus::Configuration.respond_to?(:config!)
    assert Typus::Configuration.config!.kind_of?(Hash)
  end

  def test_should_load_configuration_files_from_config_broken
    Typus.expects(:config_folder).at_least_once.returns("../config/broken")
    assert_not_equal Hash.new, Typus::Configuration.roles!
    assert_not_equal Hash.new, Typus::Configuration.config!
  end

  def test_should_load_configuration_files_from_config_empty
    Typus.expects(:config_folder).at_least_once.returns("../config/empty")
    assert_equal Hash.new, Typus::Configuration.roles!
    assert_equal Hash.new, Typus::Configuration.config!
  end

  def test_should_load_configuration_files_from_config_ordered
    Typus.expects(:config_folder).at_least_once.returns("../config/ordered")
    files = Dir[Rails.root.join(Typus.config_folder, "*_roles.yml")]
    expected = files.collect { |file| File.basename(file) }.sort
    assert_equal expected, ["001_roles.yml", "002_roles.yml"]
    expected = { "admin" => { "categories" => "read" } }
    assert_equal expected, Typus::Configuration.roles!
  end

  def test_should_load_configuration_files_from_config_unordered
    Typus.expects(:config_folder).at_least_once.returns("../config/unordered")
    files = Dir[Rails.root.join(Typus.config_folder, "*_roles.yml")]
    expected = files.collect { |file| File.basename(file) }
    assert_equal expected, ["app_one_roles.yml", "app_two_roles.yml"]
    expected = { "admin" => { "categories" => "read, update" } }
    assert_equal expected, Typus::Configuration.roles!
  end

  def test_should_load_configuration_files_from_config_default
    Typus.expects(:config_folder).at_least_once.returns("../config/default")
    assert_not_equal Hash.new, Typus::Configuration.roles!
    assert_not_equal Hash.new, Typus::Configuration.config!
    assert Typus.resources.empty?
  end

end
