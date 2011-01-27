require "test_helper"

class Admin::SearchHelperTest < ActiveSupport::TestCase

  include Admin::SearchHelper

  def render(*args); args; end

  context "search" do

    should "reject some params" do
      parameters = {"controller"=>"admin/posts",
                    "action"=>"index",
                    "locale"=>"jp",
                    "sort_order"=>"asc",
                    "order_by"=>"title"}

      expected = ["admin/helpers/search/search", {:hidden_filters => {}}]

      assert_equal expected, search(Entry, parameters)
    end

    should "reject the utf8 param because the form already contains it" do
      parameters = {"utf8"=>"✓"}
      expected = ["admin/helpers/search/search", {:hidden_filters => {}}]
      assert_equal expected, search(Entry, parameters)
    end

    should "reject the search param because the form already contains it" do
      parameters = {"search"=>"Chunky Bacon"}
      expected = ["admin/helpers/search/search", {:hidden_filters => {}}]
      assert_equal expected, search(Entry, parameters)
    end

    should "not reject applied filters" do
      parameters = {"published"=>"true", "user_id"=>"1"}

      expected = ["admin/helpers/search/search",
                  {:hidden_filters=>{"published"=>"true", "user_id"=>"1"}}]

      assert_equal expected, search(Entry, parameters)
    end

  end

end
