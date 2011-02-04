require "test_helper"

class HashTest < ActiveSupport::TestCase

  should "verify Hash#compact" do
    hash = { "a" => "", "b" => nil, "c" => "hello" }
    hash_compacted = { "c" => "hello" }
    assert_equal hash_compacted, hash.compact
  end

  context "cleanup" do

    should "work" do
      hash = {"value"=>"1000"}
      expected = {}
      assert_equal expected, hash.cleanup
    end

    should "verify whitelist for basics" do
      hash = {"controller"=>"welcome", "action"=>"index", "id" => "1"}
      expected = hash.dup
      assert_equal expected, hash.cleanup
    end

    should "verify whitelist for CKEditor stuff" do
      hash = {"CKEditor"=>"1", "CKEditorFuncNum"=>"1", "langCode"=>"en"}
      expected = hash.dup
      assert_equal expected, hash.cleanup
    end

    should "verify whitelist for layout" do
      hash = {"layout"=>"admin/headless"}
      expected = hash.dup
      assert_equal expected, hash.cleanup
    end

    should "verify whitelist for target" do
      hash = {"target"=>"_parent"}
      expected = hash.dup
      assert_equal expected, hash.cleanup
    end

  end

end
