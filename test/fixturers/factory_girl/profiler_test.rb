require "test_helper"
require "user"

module Cockroach
  class FactoryGirlProfilerTest < Test::Unit::TestCase
    context "Simple profiler" do
      setup do
        before_setup
        mock_factory_girl
        Cockroach.setup do |c|
          c.root = File.expand_path("../../../support/data/dummy_structure", __FILE__)
          c.config_path = "./config/user_only.yml"
        end
      end

      teardown do
        after_teardown
      end

      should "inherit default config" do
        profiler = nil
        
        assert_nothing_thrown do
          profiler = Cockroach::FactoryGirl::Profiler.new
        end

        assert_equal Cockroach.config.profile, profiler.instance_variable_get(:@source)
      end

      should "load! should preload nodes" do
        profiler = Cockroach::FactoryGirl::Profiler.new

        profiler.instance_variable_set(:@nodes, [])

        profiler.expects(:load)

        profiler.load!
      end
      
      context "Subnodes" do
        should "loading" do
          profiler = Cockroach::FactoryGirl::Profiler.new

          assert_nil profiler.instance_variable_get(:@loaded)

          Cockroach::FactoryGirl::Node.stubs(:new).with(any_parameters)
          Cockroach::FactoryGirl::Node.expects(:new).with("users_amount",1000)

          assert profiler.load
          assert profiler.instance_variable_get(:@loaded)
        end

        should "loading!" do
          profiler = Cockroach::FactoryGirl::Profiler.new
          
          profiler.load

          profiler.nodes.each do |node|
            node.stubs(:load!)
            node.expects(:load!)
          end

          assert profiler.load!
        end
      end
    end
  end
end
