ENV["RAILS_ENV"] = "test"

##
# Boot rails_app and load the schema.
##

require "fixtures/rails_app/config/environment"
require "fixtures/rails_app/db/schema"

require "rails/test_help"
require "factories"

class ActiveSupport::TestCase

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  def admin_sign_in
    @typus_user = Factory(:typus_user)
    set_session
  end

  def editor_sign_in
    @typus_user = Factory(:typus_user, :email => "editor@example.com", :role => "editor")
    set_session
  end

  def designer_sign_in
    @typus_user = Factory(:typus_user, :email => "designer@example.com", :role => "designer")
    set_session
  end

  def set_session
    @request.session[:typus_user_id] = @typus_user.id
  end

  def reset_session
    @request.session[:typus_user_id] = nil
  end

end
