require 'feature_test_helper'

class AddAssociatedRecordFromFormTest < Capybara::Rails::TestCase

  before do
    Typus.stubs(:authentication).returns(:none) # auth is tested elsewhere
  end

  def wait_for_animation
    sleep 0.5
  end

  test 'Adding a associated record in the form of the parent record works' do
    skip('The feature does not work at the moment')
    visit '/admin/projects/new'
    fill_in('Name', with: 'My Project')
    within('div#project_user_id_li') { click_on('Add') }
    assert_css 'h4', text: 'Add User' # wait until modal becomes visible
    # fill in user
    user = FactoryGirl.attributes_for(:typus_user)
    user_count = User.count
    within('div.modal-dialog') do
      fill_in('Name', with: 'Fritz')
      fill_in('Email', with: user[:email])
      click_on 'Save'
    end
    wait_for_animation
    #show_screen # open a screenshot in the browser. It requires the shell command 'open', don't know if
      # that's available on windows. If not, see /tmp/screenshot.png
    assert_equal user_count + 1, User.count
  end
end
