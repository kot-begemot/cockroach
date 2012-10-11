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
    def sequence_number_for(factory)
      if (@sequences ||= {})[factory].nil?
        @sequences[factory] ||= 0
      else
        @sequences[factory] += 1
      end
    end

    def mock_factory_girl
      ::FactoryGirl.stubs(:factories)
      ::FactoryGirl.stubs(:find_definitions)
      ::FactoryGirl.stubs(:factory_by_name).with("user").returns(stub('user'))
      ::FactoryGirl.stubs(:factory_by_name).with("place").returns(stub('place'))
      ::FactoryGirl.stubs(:factory_by_name).with("bird").returns(stub('bird'))
      ::FactoryGirl.stubs(:factory_by_name).with("test").raises(ArgumentError.new("Factory not registered: test"))
    end
  end
end
