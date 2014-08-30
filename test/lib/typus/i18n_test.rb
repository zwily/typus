require "test_helper"

class I18nTest < ActiveSupport::TestCase

  test "t" do
    skip("This will be removed")
    assert_equal "Hello", Typus::I18n.t("Hello")
    assert_equal "Hello", Typus::I18n.t(".hello", default: "Hello")
    assert_equal "Hello @fesplugas!", Typus::I18n.t("Hello %{human}!", human: "@fesplugas")
  end

  test "default_locale" do
    skip("This will be removed")

    assert_equal :en, Typus::I18n.default_locale
  end

  test "available_locales" do
    skip("This will be removed")
    assert Typus::I18n.available_locales.is_a?(Hash)
  end

end
