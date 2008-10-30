
ENV['RAILS_ENV'] = "test"

require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

##
# Remove the application load_paths for app/models to avoid conflicts.
#
ActiveSupport::Dependencies.load_paths.delete(File.join(RAILS_ROOT, 'app/models'))

##
# We want to have our own controllers, helpers and models to be able 
# to test the plugin without touching the application.
#
%w( models controllers helpers ).each do |folder|
  ActiveSupport::Dependencies.load_paths << File.join(RAILS_ROOT, 'vendor/plugins/typus/test/fixtures/app', folder)
end

##
# Load only the plugin view_paths to be able to test extensions.
#
ActionController::Base.view_paths = []
%w( app/views test/fixtures/app/views ).each do |folder|
  ActionController::Base.append_view_path(File.join(RAILS_ROOT, 'vendor/plugins/typus', folder))
end

require 'test/unit'
require 'action_controller/test_process'
require 'active_record/fixtures'

require File.dirname(__FILE__) + "/test_schema"

Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + '/fixtures/'

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :all
end

class ApplicationController < ActionController::Base
  helper :all
end