require "test_helper"
require "user"

module Cockroach
  class FactoryGirlNodeAliasTest < Test::Unit::TestCase
    context "Node alias" do
      def setup
        before_setup
        mock_factory_girl
        @users_node = Cockroach::FactoryGirl::Node.new('users' => {
            'amount' => '5', 
            'as' => 'person',
            'places_amount' => '10'})
      end

      def teardown
        after_teardown
      end
        
      context "Heritage" do
        should "send load! call to subnodes" do
          ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )
          ::FactoryGirl.stubs("create").with("place", any_parameters).returns(true)

          subnode = @users_node.nodes[0]
          subnode.expects(:load!).with({"person" => "user1"})
          subnode.expects(:load!).with({"person" => "user2"})
          subnode.expects(:load!).with({"person" => "user3"})
          subnode.expects(:load!).with({"person" => "user4"})
          subnode.expects(:load!).with({"person" => "user5"})

          @users_node.__send__(:load!)
        end

        should "initiate child records exact times" do
          ::FactoryGirl.stubs("create").with(any_parameters).returns(true)
          ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )

          ::FactoryGirl.expects(:create).with("place", {"person" => "user1"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"person" => "user2"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"person" => "user3"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"person" => "user4"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"person" => "user5"}).times(10)

          @users_node.__send__(:load!)
        end
      end
    end
  end
end