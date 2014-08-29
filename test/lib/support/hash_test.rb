require "test_helper"

class HashTest < ActiveSupport::TestCase

  test 'compact' do
    assert_equal({a: "A", c: "C"}, {a: "A", b: nil, c: "C"}.compact)
  end

  test "cleanup" do
    whitelist = %w(controller action id _input _popup resource attribute)
    whitelist.each do |w|
      expected = { w => w }
      assert_equal expected, expected.dup.cleanup
    end
  end

  test "cleanup rejects unwanted stuff" do
    hash = {"_nullify" => "dragonfly"}
    assert hash.cleanup.empty?
  end

end
