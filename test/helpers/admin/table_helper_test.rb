require "test/test_helper"

class Admin::TableHelperTest < ActiveSupport::TestCase

  include Admin::TableHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper

  def render(*args); args; end

  def setup
    default_url_options[:host] = "test.host"
  end

  def test_build_typus_table

    # FIXME
    return

    @current_user = typus_users(:admin)

    params = { :controller => "admin/typus_users", :action => "index" }
    self.expects(:params).at_least_once.returns(params)

    fields = TypusUser.typus_fields_for(:list)
    items = TypusUser.all

    output = build_typus_table(TypusUser, fields, items)
    expected = <<-HTML
<tr>
<th><a href="http://test.host/admin/typus_users?order_by=email">Email </a></th>
<th><a href="http://test.host/admin/typus_users?order_by=role">Role </a></th>
<th><a href="http://test.host/admin/typus_users?order_by=status">Status </a></th>
<th>&nbsp;</th>
</tr>
    HTML

    assert_equal expected, output

  end

  def test_typus_table_header

    return

    # FIXME

    @current_user = mock()
    @current_user.expects(:can?).with("delete", TypusUser).returns(true)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => "admin/typus_users", :action => "index" }
    self.expects(:params).at_least_once.returns(params)

    output = typus_table_header(TypusUser, fields)
    expected = [ "admin/helpers/table_header",
                 { :headers=> [ %(<a href="http://test.host/admin/typus_users?order_by=email">Email </a>),
                                %(<a href="http://test.host/admin/typus_users?order_by=role">Role </a>),
                                %(<a href="http://test.host/admin/typus_users?order_by=status\">Status </a>), 
                                "&nbsp;"] } ]

    assert_equal expected, output

  end

  def test_typus_table_header_with_params

    # FIXME

    return

    @current_user = mock()
    @current_user.expects(:can?).with("delete", TypusUser).returns(true)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => "admin/typus_users", :action => "index", :search => "admin" }
    self.expects(:params).at_least_once.returns(params)

    output = typus_table_header(TypusUser, fields)

    expected = [ "admin/helpers/table_header",
                 { :headers => [ %(<a href="http://test.host/admin/typus_users?order_by=email&search=admin">Email </a>), 
                                 %(<a href="http://test.host/admin/typus_users?order_by=role&search=admin">Role </a>), 
                                 %(<a href="http://test.host/admin/typus_users?order_by=status&search=admin">Status </a>), 
                                 %(&nbsp;) ] } ]

    assert_equal expected, output

  end

  def test_typus_table_header_when_user_cannot_delete_items

    return

    # FIXME

    @current_user = mock()
    @current_user.expects(:can?).with("delete", TypusUser).returns(false)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => "admin/typus_users", :action => "index" }
    self.expects(:params).at_least_once.returns(params)

    output = typus_table_header(TypusUser, fields)

    expected = [ "admin/helpers/table_header",
                 { :headers => [ %(<a href="http://test.host/admin/typus_users?order_by=email">Email </a>), 
                                 %(<a href="http://test.host/admin/typus_users?order_by=role">Role </a>), 
                                 %(<a href="http://test.host/admin/typus_users?order_by=status">Status </a>) ] } ]

    assert_equal expected, output

  end

  def test_typus_table_header_when_user_cannot_delete_items_with_params

    return

    # FIXME

    @current_user = mock()
    @current_user.expects(:can?).with("delete", TypusUser).returns(false)

    fields = TypusUser.typus_fields_for(:list)

    params = { :controller => "admin/typus_users", :action => "index", :search => "admin" }
    self.expects(:params).at_least_once.returns(params)

    output = typus_table_header(TypusUser, fields)

    expected = [ "admin/helpers/table_header",
                 { :headers => [ %(<a href="http://test.host/admin/typus_users?order_by=email&search=admin">Email </a>), 
                                 %(<a href="http://test.host/admin/typus_users?order_by=role&search=admin">Role </a>), 
                                 %(<a href="http://test.host/admin/typus_users?order_by=status&search=admin">Status </a>) ] } ]
    assert_equal expected, output

  end

  def test_typus_table_belongs_to_field

    return

    # FIXME

    @current_user = typus_users(:admin)

    comment = comments(:without_post_id)
    output = typus_table_belongs_to_field("post", comment)
    expected = "<td></td>"

    assert_equal expected, output
    default_url_options[:host] = "test.host"

    comment = comments(:with_post_id)
    output = typus_table_belongs_to_field("post", comment)
    expected = %(<td><a href="http://test.host/admin/posts/edit/1">Post#1</a></td>)

    assert_equal expected.strip, output

  end

  def test_typus_table_has_and_belongs_to_many_field

    return

    # FIXME

    post = Post.find(1)

    output = typus_table_has_and_belongs_to_many_field("comments", post)
    expected = %(<td>John<br />Me<br />Me</td>)

    assert_equal expected.strip, output

  end

  def test_typus_table_string_field

    post = posts(:published)
    output = typus_table_string_field(:title, post, :created_at)
    expected = %(<td class="title">#{post.title}</td>)

    assert_equal expected.strip, output

  end

  def test_typus_table_string_field_with_link

    post = posts(:published)
    output = typus_table_string_field(:title, post, :title)
    expected = %(<td class="title">#{post.title}</td>)

    assert_equal expected.strip, output

  end

  def test_typus_table_tree_field_when_displays_a_parent
    page = pages(:published)

    output = typus_table_tree_field("test", page)
    expected = "<td>&amp;#151;</td>"

    assert_equal expected, output
  end

  def test_typus_table_tree_field_when_displays_a_chidren
    page = pages(:unpublished)

    output = typus_table_tree_field("test", page)
    expected = "<td>Page#1</td>"

    assert_equal expected, output
  end

  def test_typus_table_datetime_field

    post = posts(:published)
    Time::DATE_FORMATS[:post_short] = "%m/%y"

    output = typus_table_datetime_field(:created_at, post)
    expected = %(<td>#{post.created_at.strftime("%m/%y")}</td>)

    assert_equal expected.strip, output

  end

  def test_typus_table_datetime_field_with_link

    post = posts(:published)
    Time::DATE_FORMATS[:post_short] = "%m/%y"

    output = typus_table_datetime_field(:created_at, post, :created_at)
    expected = %(<td>#{post.created_at.strftime("%m/%y")}</td>)

    assert_equal expected.strip, output

  end

  def test_typus_table_boolean_field

    return

    # FIXME

    post = typus_users(:admin)
    output = typus_table_boolean_field("status", post)
    expected = <<-HTML
<td><a href="http://test.host/admin/typus_users/toggle/1?field=status" onclick="return confirm('Change status?');">Active</a></td>
    HTML

    assert_equal expected.strip, output

    post = typus_users(:disabled_user)
    output = typus_table_boolean_field("status", post)
    expected = <<-HTML
<td><a href="http://test.host/admin/typus_users/toggle/3?field=status" onclick="return confirm('Change status?');">Inactive</a></td>
    HTML

    assert_equal expected.strip, output

  end

end
