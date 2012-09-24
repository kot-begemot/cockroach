require "test_helper"

module Cockroach
  class Config::LoaderTest < Test::Unit::TestCase
    context "Parser" do
      context "and Unexisting config" do
        should "raise an error for empty string" do
          assert_raise Cockroach::Config::ConfigNotExistsError do
            Cockroach::Config::Loader.parse ""
          end
        end

        should "raise an error for inexisting file" do
          assert_raise Cockroach::Config::ConfigNotExistsError do
            Cockroach::Config::Loader.parse "/no_file.yml"
          end
        end
      end
 
      context "and Correct config" do
        should "return array" do
          config = Cockroach::Config::Loader.parse File.expand_path("../support/data/correct_without_option.yml", File.dirname(__FILE__))

          assert config.is_a? Array
          assert config.first.is_a? Hash
          assert config.last.is_a? NilClass
          assert_equal 2, config.size
        end

        should "return array with options" do
          config = Cockroach::Config::Loader.parse File.expand_path("../support/data/correct_with_option.yml", File.dirname(__FILE__))

          assert config.is_a? Array
          assert config.first.is_a? Hash
          assert config.last.is_a? Hash
          assert_equal 2, config.size
        end
      end
    end
  end
end

