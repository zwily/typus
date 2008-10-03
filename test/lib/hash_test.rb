require File.dirname(__FILE__) + '/../test_helper'

class HashTest < Test::Unit::TestCase

  def test_compact
    hsh = {'a' => '', 'b'=> nil, 'c' => 'hello'}
    assert_equal hsh.compact, { 'c' => 'hello' }
  end

end