require File.dirname(__FILE__) + '/../test_helper'

class ConfigurationTest < Test::Unit::TestCase

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
    assert_equal false, Typus::Configuration.options[:special_characters_on_password]
  end

end