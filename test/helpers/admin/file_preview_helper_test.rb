require "test_helper"

class Admin::FilePreviewHelperTest < ActiveSupport::TestCase

  include Admin::FilePreviewHelper

  setup do
  end

  context "get_type_of_attachment" do

    should "return :dragonfly" do
      attachment = Factory(:asset).file
      assert_equal :dragonfly, get_type_of_attachment(attachment)
    end

    should_eventually "return :paperclip"

  end

  should_eventually "link_to_detach_attribute"
  should_eventually "typus_file_preview"
  should_eventually "typus_file_preview_for_dragonfly"
  should_eventually "typus_file_preview_for_paperclip"

end
