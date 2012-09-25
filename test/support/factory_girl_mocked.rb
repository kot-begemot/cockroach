#Hack to mock factory girl after it was loaded
require 'factory_girl'
Object.__send__(:remove_const, :FactoryGirl)
module FactoryGirl
  class << self
    attr_accessor :definition_file_paths
  end

  self.definition_file_paths = %w(factories test/factories spec/factories)

  def self.define
  end
  
  module Mock
    def mock_factory_girl
      ::FactoryGirl.stubs(:factories)
      ::FactoryGirl.stubs(:find_definitions)
      ::FactoryGirl.stubs(:factory_by_name).with("users").returns(true)
      ::FactoryGirl.stubs(:factory_by_name).with("test").raises(ArgumentError.new("Factory not registered: test"))
    end
  end
end
