
ENV["RAILS_ENV"] = "test"

# Boot rails application and testing parts ...
require "fixtures/rails_app/config/environment"
require "rails/test_help"

# As we are simulating the application we need to reload the
# configurations to get the custom paths.
Typus.reload!

# Different DB settings and load our schema.
connection = case ENV["DB"]
             when "mysql"
               { :adapter => "mysql", :database => "typus_test" }
             when "postgresql"
               { :adapter => "postgresql", :database => "typus_test", :encoding => "unicode" }
             else
               { :adapter => "sqlite3", :database => "db/test.sqlite3" }
             end

ActiveRecord::Base.establish_connection(connection)
load File.join(File.dirname(__FILE__), "schema.rb")
Dir[File.join(File.dirname(__FILE__), "factories", "**","*.rb")].each { |factory| require factory }

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end
