require "test_helper"
require "user"

module Cockroach
  class FactoryGirlSimpleAliasTest < Test::Unit::TestCase
    context "Simple alias" do
      def setup
        before_setup
        mock_factory_girl
        @users_node = Cockroach::FactoryGirl::Node.new('users' => {
            'amount' => '5', 
            'places' => {
              'amount' => '10',
              'owner_as' => 'user'
            }})
      end

      def teardown
        after_teardown
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

        should "initiate child records exact times" do
          ::FactoryGirl.stubs("create").with(any_parameters).returns(true)
          ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )

          ::FactoryGirl.expects(:create).with("place", {"owner" => "user1"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user2"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user3"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user4"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user5"}).times(10)

          @users_node.__send__(:load!)
        end
      end
    end
  end
end