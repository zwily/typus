require "test_helper"

# Here we test everything related to forms.

class Admin::PostsControllerTest < ActionController::TestCase

  # Our model definition is:
  #
  #   Post:
  #     fields:
  #       form: title, body, created_at, status, published_at
  #
  should "verify forms" do

    get :new
    assert_template :new

    assert_select "form"

    # We have 3 inputs: 1 hidden which is the UTF8 stuff, one which is the 
    # Post#title and finally the submit button.

    assert_select "form input", 3

    # Post#title: Input
    assert_select 'label[for="post_title"]'
    assert_select 'input#post_title[type="text"]'

    # We have 1 textarea
    assert_select "form textarea", 1

    # Post#body: Text Area
    assert_select 'label[for="post_body"]'
    assert_select 'textarea#post_body'

    # We have 6 selectors
    assert_select "form select", 6

    # Post#created_at: Datetime
    assert_select 'label[for="post_created_at"]'
    assert_select 'select#post_created_at_1i'
    assert_select 'select#post_created_at_2i'
    assert_select 'select#post_created_at_3i'
    assert_select 'select#post_created_at_4i'
    assert_select 'select#post_created_at_5i'

    # Post#status: Selector
    assert_select 'label[for="post_status"]'
    assert_select 'select#post_status'

    # We have 1 template

    # Post#published_at: Datetime
    assert_match "templates#datepicker_template_published_at", @response.body

  end

end
