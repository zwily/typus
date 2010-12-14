# coding: utf-8

require "test_helper"

class Admin::SidebarHelperTest < ActiveSupport::TestCase

  include Admin::SidebarHelper

  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::FormTagHelper

  def render(*args); args; end
  def link_to(*args); args; end

  setup do
    default_url_options[:host] = 'test.host'
  end

  should "test_actions"

  should "test_export" do
    params = { :controller => '/admin/posts', :action => 'index' }

    output = export(Post , params)
    expected = [["Export as CSV", { :action => "index", :format => "csv", :controller => "/admin/posts" }],
                ["Export as XML", { :action => "index", :format => "xml", :controller => "/admin/posts" }]]

    assert_equal expected, output
  end

  should_eventually "test_search" do

    @resource = TypusUser

    params = { :controller => '/admin/typus_users', :action => 'index' }
    self.expects(:params).at_least_once.returns(params)

    output = search

    partial = "admin/helpers/search"
    options = { :hidden_params => [ %(<input id="action" name="action" type="hidden" value="index" />),
                                    %(<input id="controller" name="controller" type="hidden" value="admin/typus_users" />) ],
                :search_by => "First name, Last name, Email, and Role" }

    assert_equal partial, output.first

    output.last[:hidden_params].each do |o|
      assert options[:hidden_params].include?(o)
    end
    assert options[:search_by].eql?(output.last[:search_by])

  end

  should_eventually "test_filters" do
    @resource = TypusUser
    @resource.expects(:typus_filters).returns(Array.new)
    output = filters
    assert output.nil?
  end

  should "test_filters_with_filters"

end
