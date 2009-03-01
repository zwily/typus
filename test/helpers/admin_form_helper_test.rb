require 'test/helper'

class AdminFormHelperTest < ActiveSupport::TestCase

  include AdminFormHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::DateHelper

  def test_build_form
    assert true
  end

  def test_typus_belongs_to_field
    assert true
  end

  def test_typus_boolean_field
    assert true
  end

  def test_typus_date_field
    assert true
  end

  def test_typus_datetime_field
    assert true
  end

  def test_typus_file_field
    assert true
  end

  def test_typus_password_field
    assert true
  end

  def test_typus_selector_field
    assert true
  end

  def test_typus_text_field

    output = typus_text_field('test', Post)
    expected = <<-HTML
<li><label for="item_test">Test</label>
<textarea class="text" cols="40" id="item_test" name="item[test]" rows="10"></textarea></li>
    HTML

    assert_equal expected, output

  end

  def test_typus_time_field

    output = typus_time_field('test', {}, Post)
    expected = <<-HTML
<li><label for="item_test">Test</label>
    HTML

    assert_match expected, output

  end

  def test_typus_tree_field
    assert true
  end

  def test_typus_string_field

    output = typus_string_field('test', Post)
    expected = <<-HTML
<li><label for="item_test">Test <small></small></label>
<input class="text" id="item_test" name="item[test]" size="30" type="text" /></li>
    HTML

    assert_equal expected, output

  end

  def test_typus_relationships
    assert true
  end

  def test_typus_form_has_many
    assert true
  end

  def test_typus_form_has_and_belongs_to_many
    assert true
  end

  def test_typus_template_field
    assert true
  end

  def test_attribute_disabled
    assert true
  end

  def test_expand_tree_into_select_field
    assert true
  end

end