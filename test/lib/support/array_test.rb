require "test/test_helper"

class ArrayTest < ActiveSupport::TestCase

  def test_to_hash
    keys, values = %w(a b c), %w(1 2 3)
    expected = { "a" => "1", "b" => "2", "c" => "3" }

    hash = keys.to_hash_with(values)

    assert hash.kind_of?(Hash)
    assert_equal expected, hash
  end

end
