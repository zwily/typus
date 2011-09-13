require "test_helper"

=begin

  What's being tested here?

    - Typus::Controller::Autocomplete

=end

class Admin::EntriesControllerTest < ActionController::TestCase

  setup do
    admin_sign_in
    FactoryGirl.create_list(:entry, 25)
  end

  test "autocomplete returns up to 20 items" do
    get :autocomplete, :term => "Entry"
    assert_response :success
    assert_equal 20, assigns(:items).size
  end

  test "autocomplete with only a search result" do
    post = Entry.first
    post.update_attributes(:title => "fesplugas")

    get :autocomplete, :term => "jmeiss"
    assert_response :success
    assert_equal 0, assigns(:items).size

    get :autocomplete, :term => "fesplugas"
    assert_response :success
    assert_equal 1, assigns(:items).size
  end

end
