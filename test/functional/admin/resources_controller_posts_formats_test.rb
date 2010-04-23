require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  def test_should_generate_xml
    expected = <<-RAW
<?xml version="1.0" encoding="UTF-8"?>
<posts type="array">
  <post>
    <status>unpublished</status>
    <title>Owned by admin</title>
  </post>
  <post>
    <status>unpublished</status>
    <title>Owned by editor</title>
  </post>
  <post>
    <status>published</status>
    <title>Title One</title>
  </post>
  <post>
    <status>unpublished</status>
    <title>Title Two</title>
  </post>
</posts>
    RAW

    get :index, :format => "xml"

    assert_response :success
    assert_equal expected, @response.body
  end

  def test_should_generate_csv
    expected = <<-RAW
title;status
Title One;published
Title Two;unpublished
Owned by admin;unpublished
Owned by editor;unpublished
     RAW

    get :index, :format => "csv"

    assert_response :success
    assert_equal expected, @response.body
  end

end
