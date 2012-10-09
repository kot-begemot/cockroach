module Cockroach
  module FactoryGirl
    # Loader class is designed to load the FactoryGirl fixtures, defined
    # in the project.
    class Loader
      def self.load
        old_paths = ::FactoryGirl.definition_file_paths
        if Cockroach.config.fixtures_path
          ::FactoryGirl.definition_file_paths = [Cockroach.config.fixtures_path]
        else
          ::FactoryGirl.definition_file_paths = old_paths.collect { |path| File.join(Cockroach::Config.root, path) }
        end
        ::FactoryGirl.find_definitions
        ::FactoryGirl.definition_file_paths = old_paths
      end
    end
  end
end