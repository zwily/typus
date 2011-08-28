require "test_helper"

class HashTest < ActiveSupport::TestCase

  test "compact" do
    hash = { "a" => "", "b" => nil, "c" => "hello" }
    expected = { "c" => "hello" }
    assert_equal expected, hash.compact
  end

  test "cleanup" do
    whitelist = %w(controller action id input layout resource resource_id resource_action selected back_to )
    whitelist.each do |w|
      expected = { w => w }
      assert_equal expected, expected.dup.cleanup
    end
  end

  test "cleanup rejects unwanted stuff" do
    hash = {"attribute" => "dragonfly"}
    expected = {}
    assert_equal expected, hash.cleanup
  end

end
