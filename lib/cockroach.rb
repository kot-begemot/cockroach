require 'active_support'

ActiveSupport.on_load(:after_initialize) do
  require "cockroach/railtie"
end

module Cockroach
  extend ActiveSupport::Autoload
  
  autoload :VERSION
  autoload :Config
  
  autoload_under 'fixtures' do
    autoload :FactoryGirl
  end

  mattr_reader :config

  def self.setup &block
    block.yield(Cockroach::Config)
    @@config = Cockroach::Config.new (Cockroach::Config.config_path || "config/faker.yml")
  end
end