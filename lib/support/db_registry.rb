require 'ostruct'
require_relative "./connection_adapter"

DBRegistry ||= OpenStruct.new(test: ConnectionAdapter.new("db/events-test.db"),
  development: ConnectionAdapter.new("db/events-development.db"),
  production: ConnectionAdapter.new("db/events-production.db")
  )
