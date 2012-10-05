require "test_helper"
require "generators/cockroach/install_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests Cockroach::Generators::InstallGenerator
  destination File.expand_path("../../../tmp", __FILE__)
  setup :prepare_destination

  test "Assert all files are properly created" do
    run_generator
    assert_file "config/faker.yml"
  end
end