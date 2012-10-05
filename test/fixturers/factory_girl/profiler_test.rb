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

    context "Profiling" do
      setup do
        before_setup
        mock_factory_girl
        ActiveSupport::Inflector.inflections do |inflect|
          inflect.singular /(ss)$/, '\1'
        end
        Cockroach.setup do |c|
          c.root = File.expand_path("../../../support/data/dummy_structure", __FILE__)
          c.config_path = "./config/witness.yml"
        end
        @profile = Cockroach::FactoryGirl::Profiler.new
      end
      
      should "load without error" do
        ::FactoryGirl.stubs(:factory_by_name).with(any_parameters)

        assert_nothing_thrown do
          @profile.load
        end
      end

      should "load! without error" do
        ::FactoryGirl.stubs(:factory_by_name).with(any_parameters)

        ::FactoryGirl.expects(:create).with("witness").times(6).returns( *((1..10).to_a.collect {|i| "witness#{i}"}) )
        ::FactoryGirl.expects(:create).with("message", {"author" => "witness1"}).at_least(1).at_most(6)
        ::FactoryGirl.expects(:create).with("message", {"author" => "witness2"}).at_least(1).at_most(6)
        ::FactoryGirl.expects(:create).with("message", {"author" => "witness3"}).at_least(1).at_most(6)
        ::FactoryGirl.expects(:create).with("message", {"author" => "witness4"}).at_least(1).at_most(6)
        ::FactoryGirl.expects(:create).with("message", {"author" => "witness5"}).at_least(1).at_most(6)
        ::FactoryGirl.expects(:create).with("message", {"author" => "witness6"}).at_least(1).at_most(6)

        Cockroach::FactoryGirl::Node.any_instance.stubs(:allowed_options).returns(['author'])

        @profile.load
        assert_nothing_thrown do
          @profile.load!
        end
      end
    end
  end
end
