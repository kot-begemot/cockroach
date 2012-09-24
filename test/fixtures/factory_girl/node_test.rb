require "test_helper"
require "factory_girl"
require "user"

module Cockroach
  class FactoryGirlLoadingTest < Test::Unit::TestCase
    context "Node" do
      def setup
        before_setup
      end

      def teardown
        after_teardown
      end

      context "Structure Validation" do
        should "raise error for empty hash" do
          assert_raise Cockroach::FactoryGirl::Node::InvalideStructureError do
            Cockroach::FactoryGirl::Node.new({})
          end
        end

        should "raise error for two-keys hash" do
          assert_raise Cockroach::FactoryGirl::Node::InvalideStructureError do
            Cockroach::FactoryGirl::Node.new({"one" => "1", "two" => "2"})
          end
        end

        should "raise error for not a hash" do
          [[], nil, 1, ""].each do |invalid_object|
            assert_raise Cockroach::FactoryGirl::Node::InvalideStructureError do
              Cockroach::FactoryGirl::Node.new(invalid_object)
            end
          end
 
        end
      end
      
      context "Name definition" do
        should "define name from simple structure" do
          %w(users_amount users_ratio users).each do |name|
            users_node = Cockroach::FactoryGirl::Node.new(name => '100')
            assert_equal 'users', users_node.name
          end
        end

        should "raise error if factory missing" do
          assert_raise Cockroach::FactoryGirl::Node::MissingNodeError do
            users_node = Cockroach::FactoryGirl::Node.new("test_amount" => '100')
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
  end
end
