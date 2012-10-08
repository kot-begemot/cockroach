#require 'rails/generators/generated_attribute'

module Cockroach
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Copy Faker config file into projects configuration folder"

      # all public methods in here will be run in order
      def copy_config
        template "faker.yml", "config/faker.yml"
      end

      def copy_initializer
        template "cockroach.rb", "config/initializers/cockroach.rb"
      end
    end
  end
end
