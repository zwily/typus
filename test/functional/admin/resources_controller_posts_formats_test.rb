require "test/test_helper"

class Admin::PostsControllerTest < ActionController::TestCase

  should "render index and return xml" do
    expected = <<-RAW
<?xml version="1.0" encoding="UTF-8"?>
<posts type="array">
  <post>
    <title>Owned by admin</title>
    <status>unpublished</status>
  </post>
  <post>
    <title>Owned by editor</title>
    <status>unpublished</status>
  </post>
  <post>
    <title>Title One</title>
    <status>published</status>
  </post>
  <post>
    <title>Title Two</title>
    <status>unpublished</status>
  </post>
</posts>
    RAW

    get :index, :format => "xml"

    assert_response :success
    assert_equal expected, @response.body
  end

  should "render index and return csv" do
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
