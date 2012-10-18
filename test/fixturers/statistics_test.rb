require "test_helper"
require "user"

module Cockroach
  class StatisticsTest < Test::Unit::TestCase
    setup do
      before_setup
      mock_factory_girl
      ActiveSupport::Inflector.inflections do |inflect|
        inflect.singular /(ss)$/, '\1'
      end
      Cockroach.setup do |c|
        c.root = File.expand_path("../../support/data/dummy_structure", __FILE__)
        c.config_path = "./config/witness.yml"
      end
      @profile = Cockroach::FactoryGirl::Profiler.new
      @stats = Cockroach::Statistics.new @profile
      $stdout = File.new( '/dev/null', 'w' )
    end

    teardown do
      $stdout = STDOUT
      after_teardown
    end

    context "FactorGirl" do
      setup do
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
        @profile.load!
      end

      should "print table structure" do
        @stats.expects(:header)
        @stats.expects(:print_sub_nodes).with(@profile.nodes["witness"], 0)
        @stats.expects(:footer)

        @profile.load

        @stats.print_stats!
      end

      should "return nice line" do
        Cockroach::Statistics.expects(:table_length).returns(50)

        assert_equal "* witness          *                  *        6 *",
          @stats.send(:line_for_node, @profile.nodes["witness"], 0)
      end
      should "print statistics"
    end
  end
end