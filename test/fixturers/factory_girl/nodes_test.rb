require "test_helper"
require "user"

module Cockroach
  class FactoryGirlNodesTest < Test::Unit::TestCase
    context "Nodes" do
      context "Subnodes" do
        def setup
          before_setup
          mock_factory_girl
          @users_node = Cockroach::FactoryGirl::Node.new('users' => {'amount' => '5', 'places_amount' => '10'})
        end

        def teardown
          after_teardown
        end
        
        should "create subnode" do
          assert_equal 1, @users_node.nodes.size
          
          subnode = @users_node.nodes[0]
          
          assert_instance_of Cockroach::FactoryGirl::Node, subnode
          assert_equal 'places', subnode.name
          assert_equal 'amount', subnode.approach
          assert_equal 10, subnode.amount
        end

        should "recive .load! call from supnode" do
          subnode = @users_node.nodes[0]
          subnode.expects(:load!)

          @users_node.__send__(:load_nodes!)
        end
        
        context "Heritage" do
          should "send load! call to subnodes" do
            ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )
            ::FactoryGirl.stubs("create").with("place", any_parameters).returns(true)

            subnode = @users_node.nodes[0]
            subnode.expects(:load!).with({"user" => "user1"})
            subnode.expects(:load!).with({"user" => "user2"})
            subnode.expects(:load!).with({"user" => "user3"})
            subnode.expects(:load!).with({"user" => "user4"})
            subnode.expects(:load!).with({"user" => "user5"})

            @users_node.__send__(:load!)
          end

          should "initiate parrent record exact times" do
            ::FactoryGirl.stubs("create").with(any_parameters).returns(true)
            ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )
            
            ::FactoryGirl.expects(:create).with("user").times(5)

            @users_node.__send__(:load!)
          end

          should "initiate child records exact times" do
            ::FactoryGirl.stubs("create").with(any_parameters).returns(true)
            ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )

            ::FactoryGirl.expects(:create).with("place", {"user" => "user1"}).times(10)
            ::FactoryGirl.expects(:create).with("place", {"user" => "user2"}).times(10)
            ::FactoryGirl.expects(:create).with("place", {"user" => "user3"}).times(10)
            ::FactoryGirl.expects(:create).with("place", {"user" => "user4"}).times(10)
            ::FactoryGirl.expects(:create).with("place", {"user" => "user5"}).times(10)

            @users_node.__send__(:load!)
          end
        end
      end
    end
  end
end