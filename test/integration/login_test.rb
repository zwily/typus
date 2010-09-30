require 'integration_test_helper'

class LoginTest < ActionController::IntegrationTest

  feature "Admin goes to login page" do

    scenario "views page" do
      visit '/'
    end

  end

end
