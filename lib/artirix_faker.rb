require 'active_support'

ActiveSupport.on_load(:after_initialize) do
  require "artirix_faker/railtie"
end

module ArtirixFaker
  extend ActiveSupport::Autoload
  
  autoload :VERSION
  autoload :Config
  
  autoload_under 'fixtures' do
    autoload :FactoryGirl
  end

  mattr_reader :config

  def self.setup &block
    block.yield(ArtirixFaker::Config)
    @@config = ArtirixFaker::Config.new (ArtirixFaker::Config.config_path || "config/faker.yml")
  end
end