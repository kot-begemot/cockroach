require "test_helper"

module Cockroach
  class ConfigTest < Test::Unit::TestCase
    def setup
      Cockroach::Config.root = File.expand_path("../../support/data/dummy_structure", __FILE__)
    end
    
    context "Config path assumptions" do
      should "have predefined root path" do
        assert_equal File.expand_path("../../support/data/dummy_structure", __FILE__), Cockroach::Config.root
      end

      should "assume rails root is defined" do
        Cockroach::Config.root = nil
        Rails.stubs(:root).returns("/some/fancy/path")

        assert_equal "/some/fancy/path", Cockroach::Config.root
      end
      
      #      should "assume rails root is not defined" do
      #        Cockroach::Config.root = nil
      #
      #        Object.stubs(:defined?).with(Rails).returns(false)
      #
      #        assert_raise Cockroach::Config::MissingRootPathError do
      #          Cockroach::Config.root
      #        end
      #      end

      should "deduct root path from relative path" do
        config = Cockroach::Config.new "../correct_with_option.yml"

        assert config
      end

      should "deduct root path from absolute path" do
        config = Cockroach::Config.new File.expand_path("../correct_with_option.yml", Cockroach::Config.root)

        assert config
      end     
    end

    context "Fixturers" do
      context "FactoryGirl" do
        should "be default" do
          config = Cockroach::Config.new "../correct_with_option.yml"

          assert_equal :FactoryGirl, config.fixturer
        end
      end
    end
  end

  class SetupTest < Test::Unit::TestCase
    context "Config class" do
      def setup 
        @old = Cockroach::Config.dup
      end

      def teardown
        silence_warnings { Cockroach.const_set('Config', @old) }
      end
      
      should "set root" do
        Cockroach.setup do |c|
          c.root = File.expand_path("../../support/data/dummy_structure", __FILE__)
        end

        assert_equal File.expand_path("../../support/data/dummy_structure", __FILE__), Cockroach::Config.root

      end

      should "set config_path" do
        Cockroach.setup do |c|
          c.root = File.expand_path("../../support/data/", __FILE__)
          c.config_path = "./correct_with_option.yml"
        end

        assert_equal File.expand_path("../../support/data/correct_with_option.yml", __FILE__), Cockroach.config.instance_variable_get(:@config_path)
      end

      should "set fixtures_path" do
        Cockroach.setup do |c|
          c.root = File.expand_path("../../support/data/", __FILE__)
          c.config_path = "./correct_with_option.yml"
          c.fixtures_path = "some path to fixtures"
        end

        assert_equal "some path to fixtures", Cockroach.config.instance_variable_get(:@fixtures_path)
      end

      should "set fixturer" do
        Object.const_set('FactoryBoy', mock('factory-boy'))
        Cockroach.setup do |c|
          c.root = File.expand_path("../../support/data/dummy_structure", __FILE__)
          c.fixturer = :factory_boy
        end

        config = Cockroach.config

        assert_equal :FactoryBoy, config.fixturer
        Object.__send__(:remove_const,'FactoryBoy')
      end
    end

  end
end