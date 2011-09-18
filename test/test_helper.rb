# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment",  __FILE__)

ActiveRecord::Schema.verbose = false
require File.expand_path("../dummy/db/schema",  __FILE__)

require "rails/test_help"

require "shoulda-context"

Rails.backtrace_cleaner.remove_silencers!

class ActiveSupport::TestCase

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  teardown do
    reset_session
    [Entry, Page, Post, TypusUser].each { |i| i.delete_all }
  end

  def db_adapter
    ::ActiveRecord::Base.configurations[Rails.env]['adapter']
  end

  def admin_sign_in
    @typus_user = FactoryGirl.create(:typus_user)
    set_session(@typus_user.id)
  end

  def editor_sign_in
    @typus_user = FactoryGirl.create(:typus_user, :email => "editor@example.com", :role => "editor")
    set_session(@typus_user.id)
  end

  def designer_sign_in
    @typus_user = FactoryGirl.create(:typus_user, :email => "designer@example.com", :role => "designer")
    set_session(@typus_user.id)
  end

  def set_session(id)
    @request.session[:typus_user_id] = id
  end

  def reset_session
    @request.session[:typus_user_id] = nil if @request
  end

end
