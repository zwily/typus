require 'test_helper'

=begin

  What's being tested here?

    - Admin::Format

=end

class Admin::EntriesControllerTest < ActionController::TestCase

  setup do
    admin_sign_in
  end

  test 'export csv' do
    entry = entries(:default)

    expected = <<-RAW
Title,Published
#{entry.title},#{entry.published}
     RAW

    get :index, format: 'csv'

    assert_response :success
    assert_equal expected, response.body
  end

  test 'export CSV with filters' do
    entry = entries(:default)

    expected_published = <<-RAW
Title,Published
#{entry.title},true
     RAW

    get :index, format: 'csv', published: 'true'
    assert_response :success
    assert_equal expected_published, response.body

    expected_unpublished = <<-RAW
Title,Published
     RAW

     get :index, format: 'csv', published: 'false'
     assert_response :success
     assert_equal expected_unpublished, response.body
  end

end
