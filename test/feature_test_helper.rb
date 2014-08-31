ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment",  __FILE__)

require "rails/test_help"
require "minitest/rails/capybara"
require "capybara/poltergeist"

#
# :rack_test would be the preferred default driver (it is much simpler and therefore faster).
# I haven't found a way to tag the rails tests with js: true, which would be required to turn on 
# poltergeist for tests which require JavaScript.
# Since we only write feature specs for more complex features, it's OK for now to make poltergeist the default.
#
Capybara.default_driver = :poltergeist

#
# raise an exception for missing translations so we can fix the error right away
#
Rails.application.config.action_view.raise_on_missing_translations = true

class ActiveSupport::TestCase

  fixtures :all

  self.use_transactional_fixtures = false

  teardown do
    [Entry, Page, Post, TypusUser].each { |i| i.delete_all }
  end

  def show_screen
    save_screenshot('/tmp/screenshot.png') 
    `open /tmp/screenshot.png`
  end

end