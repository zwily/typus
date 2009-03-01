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

    message = { :test => 'This is the message.' }

    output = display_flash_message(message)
    expected = <<-HTML
<div id="flash" class="test"><p>This is the message.</p></div>
    HTML

    assert_equal expected, output

    message = {}
    output = display_flash_message(message)
    assert output.nil?

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

  def test_locales

    Typus::Configuration.options[:locales] = [ [ "English", :en ], [ "Español", :es ] ]

    output = locales('set_locale')
    expected = <<-HTML
<ul>
  <li>Set language:</li>
  <li><a href="set_locale?en">English</a></li>
  <li><a href="set_locale?es">Español</a></li>
</ul>
    HTML
    assert_equal expected, output

    Typus::Configuration.options[:locales] = [ [ "English", :en ] ]

  end

end