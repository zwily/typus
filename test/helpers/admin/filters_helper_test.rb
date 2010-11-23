require "test_helper"

class Admin::FiltersHelperTest < ActiveSupport::TestCase

  include Admin::FiltersHelper

  # include ActionView::Helpers::UrlHelper

  context "build_filters" do
  end

  context "relationship_filter" do
  end

  context "date_filter" do

    should_eventually "test_date_filter" do

      @resource = TypusUser
      filter = 'created_at'

      params = { :controller => '/admin/typus_users', :action => 'index' }
      self.expects(:params).at_least_once.returns(params)

      # With an empty request.

      request = ""
      output = date_filter(request, filter)

      partial = "admin/helpers/list"
      options = { :items => [ %(<a href="http://test.host/admin/typus_users?created_at=today" class="off">Today</a>),
                              %(<a href="http://test.host/admin/typus_users?created_at=last_few_days" class="off">Last few days</a>),
                              %(<a href="http://test.host/admin/typus_users?created_at=last_7_days" class="off">Last 7 days</a>),
                              %(<a href="http://test.host/admin/typus_users?created_at=last_30_days" class="off">Last 30 days</a>) ],
                  :header => "Created at",
                  :options => { :attribute => "created_at" } }

      assert_equal [ partial, options ], output

      # With a request.

      request = "created_at=today&page=1"
      output = date_filter(request, filter)

      partial = "admin/helpers/list"
      options = { :items => [ %(<a href="http://test.host/admin/typus_users" class="on">Today</a>),
                              %(<a href="http://test.host/admin/typus_users?created_at=last_few_days" class="off">Last few days</a>),
                              %(<a href="http://test.host/admin/typus_users?created_at=last_7_days" class="off">Last 7 days</a>),
                              %(<a href="http://test.host/admin/typus_users?created_at=last_30_days" class="off">Last 30 days</a>) ],
                  :header => "Created at",
                  :options => { :attribute => "created_at" } }

      assert_equal [ partial, options ], output

    end

  end

  context "boolean_filter" do

    should_eventually "test_boolean_filter" do

      @resource = TypusUser
      filter = 'status'

      params = { :controller => '/admin/typus_users', :action => 'index' }
      self.expects(:params).at_least_once.returns(params)

      # Status is true

      request = "status=true&page=1"
      output = boolean_filter(request, filter)

      partial = "admin/helpers/list"
      options = { :items => [ %(<a href="http://test.host/admin/typus_users" class="on">Active</a>),
                              %(<a href="http://test.host/admin/typus_users?status=false" class="off">Inactive</a>) ],
                  :header => "Status",
                  :options => { :attribute => "status" } }

      assert_equal [ partial, options ], output

      # Status is false

      request = "status=false&page=1"
      output = boolean_filter(request, filter)

      partial = "admin/helpers/list"
      options = { :items => [ %(<a href="http://test.host/admin/typus_users?status=true" class="off">Active</a>),
                              %(<a href="http://test.host/admin/typus_users" class="on">Inactive</a>) ],
                  :header => "Status",
                  :options => { :attribute => "status" } }

      assert_equal [ partial, options ], output

    end

  end

  context "string_filter" do

    should_eventually "test_string_filter_when_values_are_strings" do

      @resource = TypusUser
      filter = 'role'

      params = { :controller => '/admin/typus_users', :action => 'index' }
      self.expects(:params).at_least_once.returns(params)

      # Roles is admin

      request = 'role=admin&page=1'
      # @resource.expects('role').returns(['admin', 'designer', 'editor'])
      output = string_filter(request, filter)

      expected = <<-HTML
<h2>Role</h2>
<ul>
<li><a href="http://test.host/admin/typus_users?role=admin" class="on">Admin</a></li>
<li><a href="http://test.host/admin/typus_users?role=designer" class="off">Designer</a></li>
<li><a href="http://test.host/admin/typus_users?role=editor" class="off">Editor</a></li>
</ul>
      HTML

      partial = "admin/helpers/list"
      options = { :items => [ %(<a href="http://test.host/admin/typus_users?role=admin" class="on">Admin</a>),
                              %(<a href="http://test.host/admin/typus_users?role=designer" class="off">Designer</a>),
                              %(<a href="http://test.host/admin/typus_users?role=editor" class="off">Editor</a>) ],
                  :header => "Role",
                  :options => { :attribute => "role" } }

      assert_equal [ partial, options ], output

      # Roles is editor

      request = 'role=editor&page=1'
      @resource.expects('role').returns(['admin', 'designer', 'editor'])
      output = string_filter(request, filter)

      expected = <<-HTML
<h2>Role</h2>
<ul>
<li><a href="http://test.host/admin/typus_users?role=admin" class="off">Admin</a></li>
<li><a href="http://test.host/admin/typus_users?role=designer" class="off">Designer</a></li>
<li><a href="http://test.host/admin/typus_users?role=editor" class="on">Editor</a></li>
</ul>
      HTML

      partial = "admin/helpers/list"
      options = { :items => [ %(<a href="http://test.host/admin/typus_users?role=admin" class="off">Admin</a>),
                              %(<a href="http://test.host/admin/typus_users?role=designer" class="off">Designer</a>),
                              %(<a href="http://test.host/admin/typus_users?role=editor" class="on">Editor</a>) ],
                  :header => "Role",
                  :options => { :attribute => "role" } }

      assert_equal [ partial, options ], output

    end

    should_eventually "test_string_filter_when_values_are_arrays_of_strings" do

      @resource = TypusUser
      filter = 'role'

      params = { :controller => '/admin/typus_users', :action => 'index' }
      self.expects(:params).at_least_once.returns(params)

      request = 'role=admin&page=1'

      array = [['Administrador', 'admin'],
               ['Diseñador', 'designer'],
               ['Editor', 'editor']]
      @resource.expects('role').returns(array)

      output = string_filter(request, filter)

      expected = <<-HTML
<h2>Role</h2>
<ul>
<li><a href="http://test.host/admin/typus_users?role=admin" class="on">Administrador</a></li>
<li><a href="http://test.host/admin/typus_users?role=designer" class="off">Diseñador</a></li>
<li><a href="http://test.host/admin/typus_users?role=editor" class="off">Editor</a></li>
</ul>
    HTML

      partial = "admin/helpers/list"
      options = { :items => [ %(<a href="http://test.host/admin/typus_users?role=admin" class="on">Administrador</a>),
                              %(<a href="http://test.host/admin/typus_users?role=designer" class="off">Diseñador</a>),
                              %(<a href="http://test.host/admin/typus_users?role=editor" class="off">Editor</a>) ],
                  :header => "Role",
                  :options => { :attribute => "role" } }

      assert_equal [ partial, options ], output

    end

    should_eventually "test_string_filter_when_empty_values" do
      @resource = TypusUser
      filter = 'role'
      request = 'role=admin&page=1'
      @resource.expects('role').returns([])
      output = string_filter(request, filter)

      assert output.empty?
    end

  end

  def link_to(*args); args; end

  context "remove_filter_link" do

    should "return nil when blank" do
      output = remove_filter_link("", {})
      assert_nil output
    end

    should "return link to remove search" do
      output = remove_filter_link('test', {:search => 'test'})
      expected = ["Remove search"]
      assert_equal expected, output
    end

    should "return link to remove filter" do
      output = remove_filter_link('test', {:filter => 'test'})
      expected = ["Remove filter"]
      assert_equal expected, output
    end

  end

end
