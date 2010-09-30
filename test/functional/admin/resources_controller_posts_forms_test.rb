require "test_helper"

# Here we test everything related to forms.

class Admin::PostsControllerTest < ActionController::TestCase

  # Our model definition is:
  #
  #   Post:
  #     fields:
  #       form: title, body, created_at, status, published_at
  #

  context "verify forms" do

    setup do
      get :new
      assert_template :new
    end

    should "verify forms" do
      assert_select "form"
    end

    # We have 3 inputs: 1 hidden which is the UTF8 stuff, one which is the 
    # Post#title and finally the submit button.
    should "have 3 inputs" do
      assert_select "form input", 3

      # Post#title: Input
      assert_select 'label[for="post_title"]'
      assert_select 'input#post_title[type="text"]'
    end

    should "have 1 textarea" do
      assert_select "form textarea", 1

      # Post#body: Text Area
      assert_select 'label[for="post_body"]'
      assert_select 'textarea#post_body'
    end

    should "have 6 selectors" do
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
    end

    should "have 1 template" do
      assert_match "templates#datepicker_template_published_at", @response.body
    end

  end

end
