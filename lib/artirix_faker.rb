require 'active_support'

ActiveSupport.on_load(:after_initialize) do
  require "artirix_faker/railtie"
end

module ArtirixFaker
  extend ActiveSupport::Autoload
  
  autoload :VERSION
  autoload :Config
end