require "test_helper"
require "factory_girl"

module ArtirixFaker
  class ConfigTest < Test::Unit::TestCase
    def setup
      ArtirixFaker::Config.root = File.expand_path("../../support/data/dummy_structure", __FILE__)
    end
    
    context "Config path assumptions" do
      should "have predefined root path" do
        assert_equal File.expand_path("../../support/data/dummy_structure", __FILE__), ArtirixFaker::Config.root
      end

      should "assume rails root is defined" do
        ArtirixFaker::Config.root = nil
        Rails.stubs(:root).returns("/some/fancy/path")

        assert_equal "/some/fancy/path", ArtirixFaker::Config.root
      end
      
      #      should "assume rails root is not defined" do
      #        ArtirixFaker::Config.root = nil
      #
      #        Object.stubs(:defined?).with(Rails).returns(false)
      #
      #        assert_raise ArtirixFaker::Config::MissingRootPathError do
      #          ArtirixFaker::Config.root
      #        end
      #      end

      should "deduct root path from relative path" do
        config = ArtirixFaker::Config.new "../correct_with_option.yml"

        assert config
      end

      should "deduct root path from absolute path" do
        config = ArtirixFaker::Config.new File.expand_path("../correct_with_option.yml", ArtirixFaker::Config.root)

        assert config
      end     
    end

    context "Fixturers" do
      context "FactoryGirl" do
        should "be default" do
          config = ArtirixFaker::Config.new "../correct_with_option.yml"

          assert_equal ::FactoryGirl, config.fixturer
        end
      end
    end
  end

  class SetupTest < Test::Unit::TestCase
    context "Config class" do
      def setup 
        @old = ArtirixFaker::Config.dup
      end

      def teardown
        silence_warnings { ArtirixFaker.const_set('Config', @old) }
      end
      
      should "set root" do
        ArtirixFaker.setup do |c|
          c.root = File.expand_path("../../support/data/dummy_structure", __FILE__)
        end

        assert_equal File.expand_path("../../support/data/dummy_structure", __FILE__), ArtirixFaker::Config.root

      end

      should "set config_path" do
        ArtirixFaker.setup do |c|
          c.root = File.expand_path("../../support/data/", __FILE__)
          c.config_path = "./correct_with_option.yml"
        end

        assert_equal File.expand_path("../../support/data/correct_with_option.yml", __FILE__), ArtirixFaker.config.instance_variable_get(:@config_path)
      end

      should "set fixturer" do
        Object.const_set('FactoryBoy', mock('factory-boy'))
        ArtirixFaker.setup do |c|
          c.root = File.expand_path("../../support/data/dummy_structure", __FILE__)
          c.fixturer = :factory_boy
        end

        config = ArtirixFaker.config

        assert_equal FactoryBoy, config.fixturer
        Object.__send__(:remove_const,'FactoryBoy')
      end
    end

  end
end