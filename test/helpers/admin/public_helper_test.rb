require "test/helper"

class Admin::PublicHelperTest < ActiveSupport::TestCase

  include Admin::PublicHelper

  def render(*args); args; end

  def test_quick_edit

    options = { :path => "articles/edit/1", :message => "Edit this article" }
    output = quick_edit(options)

    partial = "admin/helpers/quick_edit"
    options = { :options => { :path => "articles/edit/1", 
                              :message => "Edit this article" } }

    assert_equal [ partial, options], output

  end

  def admin_quick_edit_path
    'quick_edit'
  end

end
