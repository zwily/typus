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

  context "typus_file_preview_for_dragonfly" do

    should "return link for non image files" do
      attachment = Factory(:asset).file
      url = typus_file_preview_for_dragonfly(attachment).last
      assert_equal attachment.name, typus_file_preview_for_dragonfly(attachment).first
      assert_match /media/, typus_file_preview_for_dragonfly(attachment).last
    end

    should_eventually "return image and link for image files"

  end

  should_eventually "typus_file_preview_for_paperclip"

  def link_to(*args); args; end

end
