require "test_helper"

class I18nTest < ActiveSupport::TestCase

  test "available_locales" do
    skip("This will be removed")
    assert Typus::I18n.available_locales.is_a?(Hash)
  end

end
