ENV["RAILS_ENV"] = "test"

##
# Boot dummy and load the schema.
##

require "dummy/config/environment"
require "dummy/db/schema"

require "rails/test_help"

class ActiveSupport::TestCase

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  teardown do
    reset_session
    [Entry, Page, Post, TypusUser].each { |i| i.delete_all }
  end

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
    @request.session[:typus_user_id] = nil if @request
  end

end
