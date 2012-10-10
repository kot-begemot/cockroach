module Cockroach
  module FactoryGirl

    class NoExistingPathError < Exception; end

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

        # Italiano spagetti
        unless ::FactoryGirl.definition_file_paths.inject(false) { |valid, path| valid || File.exists?("#{path}.rb") || File.directory?(path) }
          raise NoExistingPathError.new("Neither of the paths are valid: #{::FactoryGirl.definition_file_paths.inspect}")
        end
        
        ::FactoryGirl.find_definitions
        ::FactoryGirl.definition_file_paths = old_paths
      end
    end
  end
end