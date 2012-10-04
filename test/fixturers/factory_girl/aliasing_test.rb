require "test_helper"
require "user"

module Cockroach
  class FactoryGirlAliasingTest < Test::Unit::TestCase
    setup do
      before_setup
      mock_factory_girl
    end

    teardown do
      after_teardown
    end

    context "Complex aliase" do       
      context "Heritage" do
        setup do
          @users_node = Cockroach::FactoryGirl::Node.new('users' => {
              'amount' => '5',
              'as' => 'person',
              'places' => {
                'amount' => '10',
                'owner_as' => 'person'
              }})
        end
        
        should "send load! call to subnodes" do
          ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )

          subnode = @users_node.nodes[0]
          subnode.expects(:load!).with({"person" => "user1"})
          subnode.expects(:load!).with({"person" => "user2"})
          subnode.expects(:load!).with({"person" => "user3"})
          subnode.expects(:load!).with({"person" => "user4"})
          subnode.expects(:load!).with({"person" => "user5"})

          @users_node.__send__(:load!)
        end

        should "initiate child records exact times" do
          ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )

          ::FactoryGirl.expects(:create).with("place", {"owner" => "user1"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user2"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user3"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user4"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user5"}).times(10)
          
          @users_node.nodes.each {|node| node.stubs(:allowed_options).returns(['owner']) }
          
          @users_node.__send__(:load!)
        end
      end
    end

    context "Simple alias" do
      setup do
        @users_node = Cockroach::FactoryGirl::Node.new('users' => {
            'amount' => '5',
            'places' => {
              'amount' => '10',
              'owner_as' => 'user'
            }})
      end

      context "Heritage" do
        should "send load! call to subnodes" do
          ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )
          
          subnode = @users_node.nodes[0]
          subnode.expects(:load!).with({"user" => "user1"})
          subnode.expects(:load!).with({"user" => "user2"})
          subnode.expects(:load!).with({"user" => "user3"})
          subnode.expects(:load!).with({"user" => "user4"})
          subnode.expects(:load!).with({"user" => "user5"})

          @users_node.__send__(:load!)
        end

        should "initiate child records exact times" do
          ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )

          ::FactoryGirl.expects(:create).with("place", {"owner" => "user1"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user2"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user3"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user4"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"owner" => "user5"}).times(10)

          @users_node.nodes.each {|node| node.stubs(:allowed_options).returns(['owner']) }

          @users_node.__send__(:load!)
        end
      end
    end

    context "Node alias" do
      setup do
        @users_node = Cockroach::FactoryGirl::Node.new('users' => {
            'amount' => '5',
            'as' => 'person',
            'places_amount' => '10'})
      end

      context "Heritage" do
        should "send load! call to subnodes" do
          ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )

          subnode = @users_node.nodes[0]
          subnode.expects(:load!).with({"person" => "user1"})
          subnode.expects(:load!).with({"person" => "user2"})
          subnode.expects(:load!).with({"person" => "user3"})
          subnode.expects(:load!).with({"person" => "user4"})
          subnode.expects(:load!).with({"person" => "user5"})

          @users_node.__send__(:load!)
        end

        should "initiate child records exact times" do
          ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )

          ::FactoryGirl.expects(:create).with("place", {"person" => "user1"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"person" => "user2"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"person" => "user3"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"person" => "user4"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"person" => "user5"}).times(10)

          @users_node.nodes.each {|node| node.stubs(:allowed_options).returns(['person']) }

          @users_node.__send__(:load!)
        end
      end
    end
  end
end