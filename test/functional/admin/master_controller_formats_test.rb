require 'test/helper'

class Admin::StatusControllerTest < ActionController::TestCase

  def setup
    @typus_user = typus_users(:admin)
    @request.session[:typus_user_id] = @typus_user.id
  end

=begin

  # FIXME

  def test_should_generate_xml
    assert true
  end

=end

  def test_should_generate_csv

    return if !defined?(FasterCSV)

    expected = <<-RAW
Email,Post
john@example.com,1
me@example.com,1
john@example.com,
me@example.com,1
     RAW

    get :index, :format => 'csv'
    assert_equal expected, @response.body

  end

end