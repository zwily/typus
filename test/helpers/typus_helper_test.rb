require 'test/helper'

class TypusHelperTest < ActiveSupport::TestCase

  include TypusHelper

  def test_applications
    assert true
  end

  def test_resources
    assert true
  end

  def test_typus_block
    output = typus_block(:model => 'posts', :location => 'sidebar', :partial => 'pum')
    assert output.nil?
  end

  def test_page_title
    params = {}
    Typus::Configuration.options[:app_name] = 'whatistypus.com'
    output = page_title('custom_action')
    assert_equal 'whatistypus.com &rsaquo; Custom action', output
  end

  def test_header
    output = header
    assert_match /#{Typus::Configuration.options[:app_name]}/, output
  end

  def test_login_info
    assert true
  end

  def test_display_flash_message
    assert true
  end

  def test_typus_message
    output = typus_message('chunky bacon', 'yay')
    expected = <<-HTML
<div id="flash" class="yay">
  <p>chunky bacon</p>
</div>
    HTML
    assert_equal expected, output
  end

end