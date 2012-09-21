require 'bundler'
require 'test/unit'
require "shoulda-context"
require 'ruby-debug'
require 'rails'

Bundler.setup(:default, :test)

ENV["RAILS_ENV"] = "test"

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH << File.join(File.dirname(__FILE__), 'support', 'models')
require 'artirix-faker'

require "rails/test_help"
require "rails/generators/test_case"

require File.expand_path("support/active_record", File.dirname(__FILE__))
require File.expand_path("support/database_cleaner", File.dirname(__FILE__))

class Test::Unit::TestCase
  include OrmSetup
end

