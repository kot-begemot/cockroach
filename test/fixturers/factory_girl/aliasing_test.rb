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
          mocks = ((1..5).to_a.collect {|i| stub('user', :id => i) })

          ::FactoryGirl.stubs("create").with("user").returns( *mocks )

          subnode = @users_node.nodes['place']
          subnode.expects(:load!).with({"person" => mocks[0]})
          subnode.expects(:load!).with({"person" => mocks[1]})
          subnode.expects(:load!).with({"person" => mocks[2]})
          subnode.expects(:load!).with({"person" => mocks[3]})
          subnode.expects(:load!).with({"person" => mocks[4]})

          @users_node.__send__(:load!)
        end

        should "initiate child records exact times" do
          mocks = ((1..5).to_a.collect {|i| stub('user', :id => i) })
          place_mock = stub('place', :id => 0)

          ::FactoryGirl.stubs("create").with("user").returns( *mocks )

          ::FactoryGirl.expects(:create).with("place", {"owner" => mocks[0]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"owner" => mocks[1]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"owner" => mocks[2]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"owner" => mocks[3]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"owner" => mocks[4]}).times(10).returns(place_mock)
          
          @users_node.nodes.each_value {|node| node.stubs(:allowed_options).returns(['owner']) }

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
          mocks = ((1..5).to_a.collect {|i| stub('user', :id => i) })

          ::FactoryGirl.stubs("create").with("user").returns( *mocks )
          
          subnode = @users_node.nodes['place']
          subnode.expects(:load!).with({"user" => mocks[0]})
          subnode.expects(:load!).with({"user" => mocks[1]})
          subnode.expects(:load!).with({"user" => mocks[2]})
          subnode.expects(:load!).with({"user" => mocks[3]})
          subnode.expects(:load!).with({"user" => mocks[4]})

          @users_node.__send__(:load!)
        end

        should "initiate child records exact times" do
          mocks = ((1..5).to_a.collect {|i| stub('user', :id => i) })
          place_mock = stub('place', :id => 0)

          ::FactoryGirl.stubs("create").with("user").returns( *mocks )

          ::FactoryGirl.expects(:create).with("place", {"owner" => mocks[0]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"owner" => mocks[1]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"owner" => mocks[2]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"owner" => mocks[3]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"owner" => mocks[4]}).times(10).returns(place_mock)

          @users_node.nodes.each_value {|node| node.stubs(:allowed_options).returns(['owner']) }

          @users_node.__send__(:load!)
        end
      end
    end

    context "Node alias" do
      setup do
        @users_node = Cockroach::FactoryGirl::Node.new(
          'users' => {
            'amount' => '5',
            'as' => 'person',
            'places_amount' => '10'
          })
      end

      context "Heritage" do
        should "send load! call to subnodes" do
          mocks = ((1..5).to_a.collect {|i| stub('user', :id => i) })

          ::FactoryGirl.stubs("create").with("user").returns( *mocks )

          subnode = @users_node.nodes['place']
          subnode.expects(:load!).with({"person" => mocks[0]})
          subnode.expects(:load!).with({"person" => mocks[1]})
          subnode.expects(:load!).with({"person" => mocks[2]})
          subnode.expects(:load!).with({"person" => mocks[3]})
          subnode.expects(:load!).with({"person" => mocks[4]})

          @users_node.__send__(:load!)
        end

        should "initiate child records exact times" do
          mocks = ((1..5).to_a.collect {|i| stub('user', :id => i) })
          place_mock = stub('place', :id => 0)

          ::FactoryGirl.stubs("create").with("user").returns( *mocks )

          ::FactoryGirl.expects(:create).with("place", {"person" => mocks[0]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"person" => mocks[1]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"person" => mocks[2]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"person" => mocks[3]}).times(10).returns(place_mock)
          ::FactoryGirl.expects(:create).with("place", {"person" => mocks[4]}).times(10).returns(place_mock)

          @users_node.nodes.each_value {|node| node.stubs(:allowed_options).returns(['person']) }

          @users_node.__send__(:load!)
        end
      end
    end
  end
end