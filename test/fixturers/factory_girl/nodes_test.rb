require "test_helper"
require "user"

module Cockroach
  class FactoryGirlNodesTest < Test::Unit::TestCase
    context "Nodes" do
      def setup
        before_setup
        mock_factory_girl
      end

      def teardown
        after_teardown
      end

      context "Subnodes" do
        should "create subnode" do
          users_node = Cockroach::FactoryGirl::Node.new('users' => {'amount' => '100', 'places_amount' => '10'})
          
          assert_equal 1, users_node.nodes.size
          
          subnode = users_node.nodes[0]

          assert_instance_of Cockroach::FactoryGirl::Node, subnode
          assert_equal 'places', subnode.name
          assert_equal 'amount', subnode.approach
          assert_equal 10, subnode.amount
        end

        should "recive .load! call from supnode" do
          users_node = Cockroach::FactoryGirl::Node.new('users' => {'amount' => '100', 'places_amount' => '10'})

          subnode = users_node.nodes[0]
          
          subnode.expects(:load!)

          users_node.__send__(:load_nodes!)
        end

        should "initiate records excat times" do
          users_node = Cockroach::FactoryGirl::Node.new('users' => {'amount' => '10', 'places_amount' => '10'})

          ::FactoryGirl.expects("create").with("user").times(10)
          ::FactoryGirl.expects("create").with("place").times(100)

          users_node.__send__(:load!)
        end
      end
    end
  end
end