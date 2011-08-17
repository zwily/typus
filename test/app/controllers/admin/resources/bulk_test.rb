require "test_helper"

=begin

  What's being tested here?

    - Typus::Controller::Trash

=end

class Admin::EntryBulksControllerTest < ActionController::TestCase

  setup do
    admin_sign_in
  end

  test "get index will show the available bulk_actions" do
    get :index
    assert_equal [["Move to Trash", "bulk_destroy"]], assigns(:bulk_actions)
  end

  test "get bulk_destroy removes all items" do
    @request.env['HTTP_REFERER'] = "/admin/entry_bulks"

    10.times { FactoryGirl.create(:entry_bulk) }
    items_to_destroy = EntryBulk.limit(5).map(&:id)
    items_to_keep = EntryBulk.limit(5).offset(5).map(&:id)

    get :bulk, :batch_action => "bulk_destroy", :selected_item_ids => items_to_destroy
    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']

    assert_equal items_to_keep, EntryBulk.all.map(&:id)
  end

end
