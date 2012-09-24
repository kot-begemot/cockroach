require "test_helper"
require "factory_girl"
require "user"

module Cockroach
  class FactoryGirlLoadingTest < Test::Unit::TestCase
    context "Simple profiler" do
      def setup
        Cockroach.setup do |c|
          c.root = File.expand_path("../../../support/data/dummy_structure", __FILE__)
          c.config_path = "./config/user_only.yml"
        end

        ::FactoryGirl.reset_configuration
        ::FactoryGirl.register_default_strategies
        ::FactoryGirl.register_default_callbacks
      end

      def teardown
      end

      should "loads" do
        assert_nothing_thrown do
          Cockroach::FactoryGirl::Profiler.new
        end
      end
    end
  end
end
