require "test_helper"
require "user"

module Cockroach
  class FactoryGirlLoadingTest < Test::Unit::TestCase
    context "Fixture loading" do
      def setup
        mock_factory_girl
        @old = Cockroach::Config.dup
        
        Cockroach.setup do |c|
          c.root = File.expand_path("../../../support/data/dummy_structure", __FILE__)
          c.config_path = "./config/user_only.yml"
        end
      end

      def teardown        
        silence_warnings { Cockroach.const_set('Config', @old) }
      end

      should "register fixtures" do
        ::FactoryGirl.expects(:find_definitions)

        debugger

        Cockroach::FactoryGirl::Loader.load
      end
    end
  end
end
