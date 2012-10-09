require "test_helper"
require "user"

module Cockroach
  class FactoryGirlLoadingTest < Test::Unit::TestCase
    context "Fixture loading" do
      setup do
        mock_factory_girl
        @old = Cockroach::Config.dup
        
        Cockroach.setup do |c|
          c.root = File.expand_path("../../../support/data/dummy_structure", __FILE__)
          c.config_path = "./config/user_only.yml"
        end
      end

      teardown do
        silence_warnings { Cockroach.const_set('Config', @old) }
      end

      should "register fixtures" do
        ::FactoryGirl.expects(:find_definitions)

        Cockroach::FactoryGirl::Loader.load
      end

      context "Factories path is different" do
        setup do
          Cockroach.config.instance_variable_set(:@fixtures_path, "/path/to/fixtures")
        end

        teardown do
          Cockroach.config.instance_variable_set(:@fixtures_path, nil)
        end
        should "register fixtures" do
          ::FactoryGirl.expects(:definition_file_paths=).with(["/path/to/fixtures"])
          ::FactoryGirl.expects(:definition_file_paths=).with(['factories', 'test/factories', 'spec/factories'])

          Cockroach::FactoryGirl::Loader.load
        end
      end
    end
  end
end
