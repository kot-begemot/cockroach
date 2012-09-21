require "psych"
require "yaml"

module ArtirixFaker
  class Config
    # Loader class just returns a structured and ready to use information
    # parsed from faker project yaml file.
    class ConfigNotExistsError < Exception; end

    class Loader
      CONSTRAINTS = %w(fixture_gem fixtures_path).freeze

      class << self
        # Load the file from the provided path, and return the contents as
        # an Array, with the following structure:
        #   
        #   [
        #     { * Hash containg the amounts },
        #     { * Hash containing any other options or settings }
        #   ]
        #
        def parse path_to_config
          raise ConfigNotExistsError.new("File under the path \"#{path_to_config}\", does not exists.") unless File.exists?(path_to_config)
          contents = YAML.load_file path_to_config

          options = contents.extract!(*CONSTRAINTS)
          options.delete_if {|key, value| value == nil }
          options = nil if options.blank?

          [contents, options]
        end
      end
    end
  end
end