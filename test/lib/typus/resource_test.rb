require "test/test_helper"

class ResourceTest < ActiveSupport::TestCase

  def test_should_verify_model_configuration_options
    assert_equal "edit", Typus::Resource.default_action_on_item
    assert_nil Typus::Resource.end_year
    assert_equal 15, Typus::Resource.form_rows
    assert_equal "show", Typus::Resource.action_after_save
    assert_equal 5, Typus::Resource.minute_step
    assert_equal "nil", Typus::Resource.nil
    assert_equal false, Typus::Resource.only_user_items
    assert_equal 15, Typus::Resource.per_page
    assert_nil Typus::Resource.start_year
  end

end
