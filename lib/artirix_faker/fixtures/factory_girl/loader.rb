module ArtirixFaker
  module FactoryGirl
    # Loader class is designed to load the FactoryGirl fixtures, defined
    # in the project.
    class Loader
      def self.load
        old_paths = ::FactoryGirl.definition_file_paths
        ::FactoryGirl.definition_file_paths = old_paths.collect { |path| File.join(ArtirixFaker::Config.root, path) }
        ::FactoryGirl.find_definitions
        ::FactoryGirl.definition_file_paths = old_paths
      end
    end
  end
end