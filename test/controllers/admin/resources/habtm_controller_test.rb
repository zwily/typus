require "test_helper"

=begin

  What's being tested here?

    - has_and_belongs_to

=end

class Admin::EntriesControllerTest < ActionController::TestCase

  setup do
    admin_sign_in
  end

  test 'adding multiple categories to an entry' do
    category_1 = categories(:default)
    category_2 = categories(:default)

    entry_data = {
      title: 'Title' ,
      content: 'Content',
      category_ids: ['', "#{category_1.id}", "#{category_2.id}" ]
    }

    assert_difference('Entry.count') do
      post :create, entry: entry_data
    end

    assert_equal [category_1, category_2], assigns(:item).categories
  end

end
