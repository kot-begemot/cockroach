require "test_helper"
require "user"

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
        u = ::User.create

        assert u.persisted?
      end
    end
  end
end

