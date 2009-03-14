require 'test/helper'

class AdminSidebarHelperTest < ActiveSupport::TestCase

  include AdminSidebarHelper
  include ActionView::Helpers::UrlHelper
  include ActionController::UrlWriter
  include ActionView::Helpers::TagHelper

  def setup
    default_url_options[:host] = 'test.host'
  end

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

  def test_string_filter_when_values_are_strings

    @resource = { :class => TypusUser, :self => 'typus_users' }
    request = 'roles=admin&page=1'
    filter = 'roles'

    @resource[:class].expects('roles').returns(['admin', 'designer', 'editor'])

    output = string_filter(request, filter)
    expected = <<-HTML
<h2>Roles</h2><ul>
<li><a href="http://test.host/typus/typus_users?roles=admin" class="on">Admin</a></li>
<li><a href="http://test.host/typus/typus_users?roles=designer" class="off">Designer</a></li>
<li><a href="http://test.host/typus/typus_users?roles=editor" class="off">Editor</a></li>
</ul>
    HTML

    assert_equal expected, output

    @resource[:class].expects('roles').returns(['admin', 'designer', 'editor'])

    request = 'roles=editor&page=1'
    output = string_filter(request, filter)
    expected = <<-HTML
<h2>Roles</h2><ul>
<li><a href="http://test.host/typus/typus_users?roles=admin" class="off">Admin</a></li>
<li><a href="http://test.host/typus/typus_users?roles=designer" class="off">Designer</a></li>
<li><a href="http://test.host/typus/typus_users?roles=editor" class="on">Editor</a></li>
</ul>
    HTML

    assert_equal expected, output

  end

  def test_string_filter_when_values_are_arrays_of_strings

    @resource = { :class => TypusUser, :self => 'typus_users' }
    request = 'roles=admin&page=1'
    filter = 'roles'

    array = [['Administrador', 'admin'], 
             ['Diseñador', 'designer'], 
             ['Editor', 'editor']]
    @resource[:class].expects('roles').returns(array)

    output = string_filter(request, filter)
    expected = <<-HTML
<h2>Roles</h2><ul>
<li><a href="http://test.host/typus/typus_users?roles=admin" class="on">Administrador</a></li>
<li><a href="http://test.host/typus/typus_users?roles=designer" class="off">Diseñador</a></li>
<li><a href="http://test.host/typus/typus_users?roles=editor" class="off">Editor</a></li>
</ul>
    HTML

    assert_equal expected, output

  end

  def test_string_filter_when_empty_values

    @resource = { :class => TypusUser }
    request = 'roles=admin&page=1'
    filter = 'roles'

    @resource[:class].expects('roles').returns([])
    output = string_filter(request, filter)
    assert output.empty?

  end

  private

  def params
    { :controller => 'admin/typus_users', :action => 'index' }
  end

end