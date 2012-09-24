require "test_helper"
require "factory_girl"
require "user"

module Cockroach
  class FactoryGirlLoadingTest < Test::Unit::TestCase
    context "Fixture loading" do
      def setup
        @old = Cockroach::Config.dup

        Cockroach.setup do |c|
          c.root = File.expand_path("../../../support/data/dummy_structure", __FILE__)
          c.config_path = "./config/user_only.yml"
        end

        ::FactoryGirl.reset_configuration
        ::FactoryGirl.register_default_strategies
        ::FactoryGirl.register_default_callbacks
      end

      def teardown        
        silence_warnings { Cockroach.const_set('Config', @old) }
      end

      should "register fixtures" do
        ::FactoryGirl.expects(:find_definitions)
        Cockroach::FactoryGirl::Loader.load
      end

      should "load fixtures" do
        assert_raise ArgumentError.new "Factory not registered: user" do
          assert ::FactoryGirl.factories.find('user')
        end

        Cockroach::FactoryGirl::Loader.load

        assert ::FactoryGirl.factories.find('user')
      end
    end
  end
end
