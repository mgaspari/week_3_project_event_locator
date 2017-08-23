require 'bundler'
Bundler.require

# require 'require_all'
require 'pry'
# require 'active_record'
require 'rake'

# require_relative '../lib/support/db_registry.rb'


ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/events.db')

# DBRegistry[ENV["EVENTS_ENV"]].connect!
# DB = ActiveRecord::Base.connection

# if ENV["EVENTS_ENV"] == "test"
#   ActiveRecord::Migration.verbose = false
# end

old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "../lib/support", "*.rb")].each {|f| require f}
