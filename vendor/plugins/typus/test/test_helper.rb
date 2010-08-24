
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
             when "pg"
               { :adapter => "postgresql", :database => "typus_test", :encoding => "unicode" }
             else
               { :adapter => "sqlite3", :database => ":memory:" }
             end

ActiveRecord::Base.establish_connection(connection)
load File.join(File.dirname(__FILE__), "schema.rb")
Dir[File.join(File.dirname(__FILE__), "factories", "**","*.rb")].each { |factory| require factory }

# To test the plugin without touching the application we set our
# load_paths and view_paths.

%w( models controllers helpers ).each do |folder|
  ActiveSupport::Dependencies.load_paths << File.join(Typus.root, "app", folder)
end

ActionController::Base.append_view_path(File.join(Typus.root, "app/views"))

class ActiveSupport::TestCase
  self.fixture_path = File.dirname(__FILE__) + "/fixtures"
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  fixtures :typus_users, :posts
end
