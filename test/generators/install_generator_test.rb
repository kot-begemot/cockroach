require "test_helper"
require "generators/install_generator"

class InstallGeneratorTest < Rails::Generators::TestCase
  tests ArtirixFaker::Generators::InstallGenerator
  destination File.expand_path("../../../tmp", __FILE__)
  setup :prepare_destination

  test "Assert all files are properly created" do
    run_generator
    assert_file "config/faker.yml"
  end
end