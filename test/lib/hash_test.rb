require File.dirname(__FILE__) + '/../test_helper'

class HashTest < Test::Unit::TestCase

  def test_should_verify_compact
    hsh = { 'a' => '', 'b'=> nil, 'c' => 'hello' }
    assert_equal ({ 'c' => 'hello' }), hsh.compact
  end

end