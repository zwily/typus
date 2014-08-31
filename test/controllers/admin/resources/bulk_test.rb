require "test_helper"

=begin

  What's being tested here?

    - Admin::Trash

=end

class Admin::EntryBulksControllerTest < ActionController::TestCase

  setup do
    admin_sign_in
    @request.env['HTTP_REFERER'] = '/admin/entry_bulks'
    create_x_items
  end

  test 'get index shows available bulk_actions' do
    get :index
    expected = [
      ['typus.buttons.move_to_trash', 'bulk_destroy'],
      ['typus.buttons.mark_published', 'bulk_publish'],
      ['typus.buttons.mark_published', 'bulk_unpublish']
    ]
    assert_equal expected, assigns(:bulk_actions)
  end

  test 'get bulk_destroy removes all items' do
    items_to_destroy = EntryBulk.limit(5).map(&:id)
    items_to_keep = EntryBulk.limit(5).offset(5).map(&:id)

    get :bulk, batch_action: 'bulk_destroy', selected_item_ids: items_to_destroy
    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']

    assert_equal items_to_keep, EntryBulk.all.map(&:id)
  end

  test 'get bulk with empty action and selected items redirects to back with a feedback message' do
    items = EntryBulk.limit(5).map(&:id)

    get :bulk, batch_action: '', selected_item_ids: items
    assert_response :redirect
    assert_redirected_to @request.env['HTTP_REFERER']

    assert_equal 'No bulk action selected.', flash[:notice]
  end

  def create_x_items
    10.times do  |i|
      EntryBulk.create(
        title: "EntryBulk #{i}",
        content: 'Default Content of the Default EntryBulk'
      )
    end
  end

end
