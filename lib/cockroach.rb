require 'active_support'
require "cockroach/railtie" if defined?(Rails)

module Cockroach
  extend ActiveSupport::Autoload
  
  autoload :VERSION
  autoload :Config

  module Base
    autoload :Node, 'cockroach/base/node'
    autoload :LoadNodes, 'cockroach/base/load_nodes'
  end
  
  autoload_under 'fixtures' do
    autoload :FactoryGirl
  end

  class InvalideStructureError < Exception; end
  class MissingFixtureError < Exception; end

  mattr_reader :config

  def self.setup &block
    block.yield(Cockroach::Config)
    @@config = Cockroach::Config.new (Cockroach::Config.config_path || "config/faker.yml")
    load_fixturer
  end
  
  private

  #
  def self.load_fixturer
    self.const_get(@@config.fixturer)
  end
end