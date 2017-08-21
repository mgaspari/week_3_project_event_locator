require 'bundler/setup'
Bundler.require

require 'pry'
require 'active_record'
require 'rake'

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "../lib/support", "*.rb")].each {|f| require f}

DBRegistry[ENV["EVENTS_ENV"]].connect!
DB = ActiveRecord::Base.connection

if ENV["EVENTS_ENV"] == "test"
  ActiveRecord::Migration.verbose = false
end
