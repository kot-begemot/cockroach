require 'active_support'

ActiveSupport.on_load(:after_initialize) do
  require "artirix_faker/railtie"
end

module ArtirixFaker
  autoload :VERSION, "artirix_faker/version"
  
  module Models
    extend ActiveSupport::Autoload
    
    autoload :User
  end

end