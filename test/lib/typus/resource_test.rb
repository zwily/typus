require "test_helper"

class ResourceTest < ActiveSupport::TestCase

  should "verify default resource configuration options" do
    assert_equal "edit", Typus::Resources.default_action_on_item
    assert Typus::Resources.end_year.nil?
    assert_equal 15, Typus::Resources.form_rows
    assert_equal "edit", Typus::Resources.action_after_save
    assert_equal 5, Typus::Resources.minute_step
    assert_equal "nil", Typus::Resources.human_nil
    assert !Typus::Resources.only_user_items
    assert_equal 15, Typus::Resources.per_page
    assert Typus::Resources.start_year.nil?
    assert_equal 500, Typus::Resources.habtm_limit
  end

end
