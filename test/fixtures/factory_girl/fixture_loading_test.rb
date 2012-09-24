require "test_helper"
require "factory_girl"
require "user"

module ArtirixFaker
  class FactoryGirlLoadingTest < Test::Unit::TestCase
    context "Fixture loading" do
      def setup
        @old = ArtirixFaker::Config.dup

        ArtirixFaker.setup do |c|
          c.root = File.expand_path("../../../support/data/dummy_structure", __FILE__)
          c.config_path = "./config/user_only.yml"
        end

        ::FactoryGirl.reset_configuration
        ::FactoryGirl.register_default_strategies
        ::FactoryGirl.register_default_callbacks
      end

      def teardown        
        silence_warnings { ArtirixFaker.const_set('Config', @old) }
      end

      should "register fixtures" do
        ::FactoryGirl.expects(:find_definitions)
        ArtirixFaker::FactoryGirl::Loader.load
      end

      should "load fixtures" do
        assert_raise ArgumentError.new "Factory not registered: user" do
          assert ::FactoryGirl.factories.find('user')
        end

        ArtirixFaker::FactoryGirl::Loader.load

        assert ::FactoryGirl.factories.find('user')
      end
    end
  end
end
