require "test_helper"

class Admin::SearchHelperTest < ActiveSupport::TestCase

  include Admin::SearchHelper

  def render(*args); args; end

  context "search" do

    should "reject some params" do
      parameters = {"controller"=>"admin/posts",
                    "action"=>"index",
                    "locale"=>"jp",
                    "utf8"=>"✓",
                    "sort_order"=>"asc",
                    "order_by"=>"title",
                    "search"=>"Chunky Bacon"}

      expected = ["admin/helpers/search/search", { :hidden_filters => {} }]

      assert_equal expected, search(Entry, parameters)
    end

    should "work" do
      parameters = {"published"=>"true", "user_id"}

      expected = ["admin/helpers/search/search",
                  {:hidden_filters=>{"published"=>"true"}}]

      assert_equal expected, search(Entry, parameters)
    end

  end

end
