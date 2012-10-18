require "test_helper"
require "user"

module Cockroach
  class FactoryGirlProfilerTest < Test::Unit::TestCase
    setup do
      before_setup
      mock_factory_girl
    end
    
    teardown do
      after_teardown
    end

    context "Complex profiler" do
      context "Naming" do
        should "load same named nodes with different aliases" do
          config = stub('config', :fixtures_path => File.expand_path("../../../support/data/dummy_structure/test", __FILE__) )
          config.stubs(:profile).returns({
              "user" => [{
                  "amount" => "10",
                  "as" => "witness"
                },{
                  "amount" => "10",
                  "as" => "perpetrator"
                }]
            })
          Cockroach.stubs(:config).returns(config)
          profiler = Cockroach::FactoryGirl::Profiler.new config
          Cockroach.stubs(:profiler).returns(profiler)

          profiler.load

          assert_not_nil Cockroach.profiler["witness"]
          assert_not_nil Cockroach.profiler["perpetrator"]
        end
      end
    end

    context "Simple profiler" do
      setup do
        Cockroach.setup do |c|
          c.root = File.expand_path("../../../support/data/dummy_structure", __FILE__)
          c.config_path = "./config/user_only.yml"
        end
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

        profiler.instance_variable_set(:@nodes, {})

        profiler.expects(:load)

        profiler.load!
      end

      context "Subnodes" do

        context "Access" do
          should "be from top level" do
            profiler = Cockroach::FactoryGirl::Profiler.new
            assert_equal @users_node, profiler['person']
          end
        end

        should "loading" do
          profiler = Cockroach::FactoryGirl::Profiler.new

          assert_nil profiler.instance_variable_get(:@loaded)

          fake_node = mock()
          fake_node.stubs(:node_name).returns('name')
          Cockroach::FactoryGirl::Node.stubs(:new).with(any_parameters).returns(fake_node)
          Cockroach::FactoryGirl::Node.expects(:new).with("users_amount",1000).returns(fake_node)

          assert profiler.load
          assert profiler.instance_variable_get(:@loaded)
        end

        should "loading!" do
          profiler = Cockroach::FactoryGirl::Profiler.new

          profiler.load

          profiler.nodes.each_value do |node|
            node.stubs(:load!)
            node.expects(:load!)
          end

          assert profiler.load!
        end
      end
    end

    context "Profiling" do
      setup do
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

        mocks = ((1..6).to_a.collect {|i| stub('witness', :id => i) })
        message_mock = stub('message', :id => 0)

        ::FactoryGirl.expects(:create).with("witness").times(6).returns( *mocks )

        ::FactoryGirl.expects(:create).with("message", {"author" => mocks[0]}).at_least(1).at_most(6).returns(message_mock)
        ::FactoryGirl.expects(:create).with("message", {"author" => mocks[1]}).at_least(1).at_most(6).returns(message_mock)
        ::FactoryGirl.expects(:create).with("message", {"author" => mocks[2]}).at_least(1).at_most(6).returns(message_mock)
        ::FactoryGirl.expects(:create).with("message", {"author" => mocks[3]}).at_least(1).at_most(6).returns(message_mock)
        ::FactoryGirl.expects(:create).with("message", {"author" => mocks[4]}).at_least(1).at_most(6).returns(message_mock)
        ::FactoryGirl.expects(:create).with("message", {"author" => mocks[5]}).at_least(1).at_most(6).returns(message_mock)

        Cockroach::FactoryGirl::Node.any_instance.stubs(:allowed_options).returns(['author'])

        @profile.load
        assert_nothing_thrown do
          @profile.load!
        end
      end
    end
  end
end
