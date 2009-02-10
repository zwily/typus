require 'test/helper'

class AdminSidebarHelperTest < ActiveSupport::TestCase

  include AdminSidebarHelper

  def test_actions
    assert true
  end

  def test_default_actions
    assert true
  end

  def test_non_crud_actions
    assert true
  end

  def test_build_typus_list

    output = build_typus_list([], header = nil)
    assert output.empty?

    output = build_typus_list(['item1', 'item2'], "Chunky Bacon")
    assert !output.empty?
    assert_match /Chunky bacon/, output

    output = build_typus_list(['item1', 'item2'])
    assert !output.empty?
    assert_no_match /h2/, output
    assert_no_match /\/h2/, output

  end

  def test_modules
    assert true
  end

  def test_previous_and_next
    assert true
  end

  def test_search
    assert true
  end

  def test_filters
    assert true
  end

  def test_relationship_filter
    assert true
  end

  def test_datetime_filter
    assert true
  end

  def test_boolean_filter
    assert true
  end

  def test_string_filter
    assert true
  end

end