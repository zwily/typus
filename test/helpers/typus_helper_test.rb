require 'test/test_helper'

class TypusHelperTest < Test::Unit::TestCase

  include TypusHelper

  def test_header
    output = header
    assert_match /#{Typus::Configuration.options[:app_name]}/, output
  end

  def test_typus_message
    output = typus_message('chunky bacon', 'yay')
    assert_match "<div id=\"flash\" class=\"yay\">", output
    assert_match /<p>chunky bacon<\/p>/, output
  end

  def test_typus_block
    output = typus_block(:model => 'posts', :location => 'sidebar', :partial => 'pum')
    assert output.nil?
  end

end