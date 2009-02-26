require 'test/helper'

class AdminTableHelperTest < ActiveSupport::TestCase

  include AdminTableHelper

  def test_build_typus_table
    assert true
  end

  def test_typus_table_header
    assert true
  end

  def test_typus_table_belongs_to_field
    assert true
  end

  def test_typus_table_has_and_belongs_to_many_field
    assert true
  end

  def test_typus_table_string_field

    post = posts(:published)

    output = typus_table_string_field(:title, post, :created_at)
    assert_equal "<td>#{post.title}</td>\n", output

  end

  def test_typus_table_tree_field
    assert true
  end

  def test_typus_table_position_field
    assert true
  end

  def test_typus_table_datetime_field

    post = posts(:published)
    Time::DATE_FORMATS[:post_short] = '%m/%y'

    output = typus_table_datetime_field(:created_at, post)
    assert_equal "<td>11/07</td>\n", output

  end

  def test_typus_table_boolean_field

    # FIXME: Here I should use mocks.

    Typus::Configuration.options[:icon_on_boolean] = false
    Typus::Configuration.options[:toggle] = false

    post = posts(:published)
    output = typus_table_boolean_field(:status, post)
    assert_equal "<td align=\"center\">True</td>\n", output

    post = posts(:unpublished)
    output = typus_table_boolean_field(:status, post)
    assert_equal "<td align=\"center\">False</td>\n", output

    Typus::Configuration.options[:icon_on_boolean] = true
    Typus::Configuration.options[:toggle] = true

  end

end