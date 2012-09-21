require 'logger'
require "active_record"

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => ':memory:'
)

ActiveRecord::Migration.verbose = false
#ActiveRecord::Migration.verbose = true
#ActiveRecord::Base.logger = Logger.new(STDOUT)
