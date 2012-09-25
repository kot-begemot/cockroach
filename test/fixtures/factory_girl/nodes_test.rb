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
      end
    end
  end
end