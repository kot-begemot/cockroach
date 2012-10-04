require "test_helper"
require "user"

module Cockroach
  class FactoryGirlNodeTest < Test::Unit::TestCase
    setup do
      before_setup
      mock_factory_girl
    end

    teardown do
      after_teardown
    end
    
    context "Node" do
      context "Structure Validation" do
        should "raise error for empty hash" do
          assert_raise Cockroach::InvalideStructureError do
            Cockroach::FactoryGirl::Node.new({})
          end
        end

        should "raise error for two-keys hash" do
          assert_raise Cockroach::InvalideStructureError do
            Cockroach::FactoryGirl::Node.new({"one" => "1", "two" => "2"})
          end
        end

        should "raise error for not a hash" do
          [[], nil, 1, ""].each do |invalid_object|
            assert_raise Cockroach::InvalideStructureError do
              Cockroach::FactoryGirl::Node.new(invalid_object)
            end
          end
        end
      end
      
      context "Initialization" do
        should "should accept hash" do
          user_node = nil
          
          assert_nothing_thrown do
            user_node = Cockroach::FactoryGirl::Node.new({ "users" => { 'amount' => '100', 'places_amount' => '10' }})
          end 
          
          assert_equal({'amount' => '100'}, user_node.instance_variable_get(:@options))
          assert_equal({'places_amount' => '10'}, user_node.instance_variable_get(:@structure))
        end

        should "should accept params" do
          user_node = nil
          
          assert_nothing_thrown do
            user_node = Cockroach::FactoryGirl::Node.new "users", { 'amount' => '100', 'places_amount' => '10' }
          end

          assert_equal({'amount' => '100'}, user_node.instance_variable_get(:@options))
          assert_equal({'places_amount' => '10'}, user_node.instance_variable_get(:@structure))
        end
      end
      
      context "Name definition" do
        context "Info extracting" do
          should "get options" do
            structure = { "users" => { 'amount' => '100', 'places_amount' => '10' }}

            user_node = Cockroach::FactoryGirl::Node.new structure

            assert_equal({'amount' => '100'}, user_node.instance_variable_get(:@options))
            assert_equal({'places_amount' => '10'}, user_node.instance_variable_get(:@structure))
          end

          should "get user name without approach" do
            assert_equal ["users",nil], Cockroach::FactoryGirl::Node.extract_info("users")
          end

          should "get user name with approach: amount" do
            assert_equal ["users", "amount"], Cockroach::FactoryGirl::Node.extract_info("users_amount")
          end

          should "get user name with approach: ratio" do
            assert_equal ["users", "ratio"], Cockroach::FactoryGirl::Node.extract_info("users_ratio")
          end
        end

        should "define name from simple structure" do
          users_node = Cockroach::FactoryGirl::Node.new('users_amount' => '100')
          assert_equal 'users', users_node.name
          assert_equal 100, users_node.amount


          users_node = Cockroach::FactoryGirl::Node.new('users_ratio' => '100')
          assert_equal 'users', users_node.name
          assert users_node.amount.kind_of? Numeric
        end

        should "define name from subsequntil structure" do
          users_node = Cockroach::FactoryGirl::Node.new('users' => { 'amount' => '100'})
          assert_equal 'users', users_node.name
          assert_equal 100, users_node.amount

          users_node = Cockroach::FactoryGirl::Node.new('users' => { 'ratio' => '100'})
          assert_equal 'users', users_node.name
          assert users_node.amount.kind_of? Numeric
          
          users_node = Cockroach::FactoryGirl::Node.new('users' => { 'ratio' => { 'lower_limit' => '50', 'upper_limit' => '300'}})
          assert_equal 'users', users_node.name
          assert users_node.amount.kind_of? Numeric
        end

        should "raise error if factory missing" do
          assert_raise ArgumentError do
            users_node = Cockroach::FactoryGirl::Node.new("test_amount" => '100')
          end
        end

        should "raise error if approach missing" do
          assert_raise Cockroach::InvalideStructureError do
            users_node = Cockroach::FactoryGirl::Node.new("users" => {})
          end
        end
      end

      context "Amount generated" do
        should "simple amount" do
          users_node = Cockroach::FactoryGirl::Node.new('users_amount' => '100')
          assert_equal 100, users_node.amount
        end

        should "simple relation" do
          users_node = Cockroach::FactoryGirl::Node.new('users_ratio' => '100')
          users_node.expects(:get_limits).returns([50, 200])
          assert users_node.amount.is_a?(Integer)
        end

        should "subsequent amount" do
          users_node = Cockroach::FactoryGirl::Node.new('users' => {'amount' => '100'})
          assert_equal 100, users_node.amount
        end

        should "subsequent relation" do
          users_node = Cockroach::FactoryGirl::Node.new('users' => {'ratio' => '100'})
          users_node.expects(:get_limits).returns([50, 200])
          assert users_node.amount.is_a?(Integer)
        end

        should "subsequent relation with limits" do
          users_node = Cockroach::FactoryGirl::Node.new('users' => {'ratio' => {'lower_limit' => 50, 'upper_limit' => 300}})
          users_node.expects(:get_limits).returns([50, 300])
          assert users_node.amount.is_a?(Integer)
        end
      end
    end

    context "Subnode" do
      setup do
        @users_node = Cockroach::FactoryGirl::Node.new('users' => {'amount' => '5', 'places_amount' => '10'})
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

          subnode = @users_node.nodes[0]
          subnode.expects(:load!).with({"user" => "user1"})
          subnode.expects(:load!).with({"user" => "user2"})
          subnode.expects(:load!).with({"user" => "user3"})
          subnode.expects(:load!).with({"user" => "user4"})
          subnode.expects(:load!).with({"user" => "user5"})

          @users_node.__send__(:load!)
        end

        should "initiate parrent record exact times" do
          ::FactoryGirl.expects(:create).with("user").times(5).returns( *((1..10).to_a.collect {|i| "user#{i}"}) )
          ::FactoryGirl.stubs(:create).with("place", any_parameters)

          @users_node.nodes.each {|node| node.stubs(:allowed_options).returns(['user']) }

          @users_node.__send__(:load!)
        end

        should "initiate child records exact times" do
          ::FactoryGirl.stubs("create").with("user").returns( *((1..10).to_a.collect {|i| "user#{i}"}) )

          ::FactoryGirl.expects(:create).with("place", {"user" => "user1"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"user" => "user2"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"user" => "user3"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"user" => "user4"}).times(10)
          ::FactoryGirl.expects(:create).with("place", {"user" => "user5"}).times(10)

          @users_node.nodes.each {|node| node.stubs(:allowed_options).returns(['user']) }

          @users_node.__send__(:load!)
        end
      end
    end
  end
end
