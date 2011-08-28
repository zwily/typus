require "test_helper"

class I18nTest < ActiveSupport::TestCase

  test "t" do
    assert_equal "Missing Translation", Typus::I18n.t("Missing Translation")
  end

  test "default_locale" do
    assert_equal :en, Typus::I18n.default_locale
  end

  test "available_locales" do
    assert Typus::I18n.available_locales.is_a?(Hash)
  end

end
