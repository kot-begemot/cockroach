require "test_helper"
require "user"
require "user_factory"

module ArtirixFaker
  class UserTest < Test::Unit::TestCase
    context "User" do
      def setup
        before_setup
      end

      def teardown
        after_teardown
      end

      should "be creatable" do
        u = ::User.create first_name: "Anton", last_name: "Checkov", email: "anton.pavlovich@russian-writers.com"

        assert u.persisted?
      end

      context "through FactoryGirl" do
#        should "be factorable" do
#
#          u = ::FactoryGirl.create(:user)
#
#          assert u.persisted?
#        end
      end
    end
  end
end

