require 'test/helper'

class AdminHelperTest < ActiveSupport::TestCase

  include AdminHelper

  def test_remove_filter_link
    output = remove_filter_link('')
    assert output.nil?
  end

  def test_display_link_to_previous
    assert true
  end

  def test_build_list
    assert true
  end

  def test_build_pagination
    assert true
  end

end