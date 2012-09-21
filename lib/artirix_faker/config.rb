module ArtirixFaker
  class Config
    extend ActiveSupport::Autoload
    
    autoload :Loader
    autoload :ConfigNotExistsError, 'artirix_faker/config/loader'
  end
end