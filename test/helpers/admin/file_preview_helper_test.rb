require "test_helper"

class Admin::FilePreviewHelperTest < ActiveSupport::TestCase

  include Admin::FilePreviewHelper

  setup do
    @asset = Factory(:asset)
  end

  context "get_type_of_attachment" do

    should "return :dragonfly" do
      assert_equal :dragonfly, get_type_of_attachment(@asset.file)
    end

    should "return :paperclip" do
      assert_equal :paperclip, get_type_of_attachment(@asset.paperclip)
    end

  end

  should_eventually "link_to_detach_attribute"
  should_eventually "typus_file_preview"

  context "typus_file_preview_for_dragonfly" do

    should "return link for non image files" do
      assert_equal @asset.file.name, typus_file_preview_for_dragonfly(@asset.file).first
      assert_match /media/, typus_file_preview_for_dragonfly(@asset.file).last
    end

    should_eventually "return image and link for image files"

  end

  context "typus_file_preview_for_paperclip" do

    should "return link for non image files" do
      Typus.expects(:file_preview).at_least_once.returns(nil)
      assert_equal "rails.png", typus_file_preview_for_paperclip(@asset.paperclip).first
      assert_equal "/system/paperclips/1/original/rails.png", typus_file_preview_for_paperclip(@asset.paperclip).last
    end

    should "return image and link for image files" do
      expected = ["admin/helpers/file_preview",
                  {:preview => "/system/paperclips/1/medium/rails.png",
                   :thumb => "/system/paperclips/1/thumb/rails.png"}]
      assert_equal expected, typus_file_preview_for_paperclip(@asset.paperclip)
    end

  end

  def link_to(*args); args; end
  def render(*args); args; end

end
