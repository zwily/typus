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

    output = typus_boolean_field('test', Post)

    expected = if Rails.version == '2.2.2'
                 <<-HTML
<li><label for="item_test">Test</label>
<input id="item_test" name="item[test]" type="checkbox" value="1" /><input name="item[test]" type="hidden" value="0" /> Checked if active</li>
                 HTML
               else
                 <<-HTML
<li><label for="item_test">Test</label>
<input name="item[test]" type="hidden" value="0" /><input id="item_test" name="item[test]" type="checkbox" value="1" /> Checked if active</li>
                 HTML
               end

    assert_equal expected, output

    Post.expects(:typus_field_options_for).with(:questions).returns('test')
    output = typus_boolean_field('test', Post)
    assert_match /Test?/, output

  end

  def test_typus_date_field

    output = typus_date_field('test', {}, Post)
    expected = <<-HTML
<li><label for="item_test">Test</label>
    HTML

    assert_match expected, output

  end

  def test_typus_datetime_field

    output = typus_datetime_field('test', {}, Post)
    expected = <<-HTML
<li><label for="item_test">Test</label>
    HTML

    assert_match expected, output

  end

  def test_typus_file_field

    output = typus_file_field('asset_file_name', Post)
    expected = <<-HTML
<li><label for="item_asset_file_name">Asset</label>
<input id="item_asset" name="item[asset]" size="30" type="file" /></li>
    HTML

    assert_equal expected, output

  end

  def test_typus_password_field

    output = typus_password_field('test', Post)
    expected = <<-HTML
<li><label for="item_test">Test</label>
<input class="text" id="item_test" name="item[test]" size="30" type="password" /></li>
    HTML

    assert_equal expected, output

  end

  def test_typus_selector_field

    @resource = { :class => Post }
    @item = posts(:published)

    output = typus_selector_field('status')

    expected = <<-HTML
<li><label for="item_status">Status</label>
<select id="item_status"  name="item[status]">
<option value=""></option>
<option selected value="true">true</option>
<option  value="false">false</option>
<option  value="pending">pending</option>
<option  value="published">published</option>
<option  value="unpublished">unpublished</option>
</select></li>
    HTML

    assert_equal expected, output

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

    assert !attribute_disabled?('test', Post)

    Post.expects(:accessible_attributes).returns(['test'])
    assert !attribute_disabled?('test', Post)

    Post.expects(:accessible_attributes).returns(['no_test'])
    assert attribute_disabled?('test', Post)

  end

  def test_expand_tree_into_select_field
    return unless defined? ActiveRecord::Acts::Tree

    items = Page.roots

    # Page#1 is a root.

    @item = Page.find(1)
    output = expand_tree_into_select_field(items, 'parent_id')
    expected = <<-HTML
<option  value="1"> &#92;_ Page#1</option>
<option  value="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#92;_ Page#2</option>
<option  value="3"> &#92;_ Page#3</option>
<option  value="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#92;_ Page#4</option>
<option  value="5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#92;_ Page#5</option>
<option  value="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#92;_ Page#6</option>
    HTML
    assert_equal expected, output

    # Page#4 is a children.

    @item = Page.find(4)
    output = expand_tree_into_select_field(items, 'parent_id')
    expected = <<-HTML
<option  value="1"> &#92;_ Page#1</option>
<option  value="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#92;_ Page#2</option>
<option selected value="3"> &#92;_ Page#3</option>
<option  value="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#92;_ Page#4</option>
<option  value="5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#92;_ Page#5</option>
<option  value="6">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &#92;_ Page#6</option>
    HTML
    assert_equal expected, output

  end

end