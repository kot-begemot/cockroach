module Cockroach
  class Config
    extend ActiveSupport::Autoload
    
    autoload :Loader
    autoload :ConfigNotExistsError, 'cockroach/config/loader'

    class MissingRootPathError < Exception; end

    class << self
      attr_writer :root
      attr_accessor :fixturer, :config_path, :fixtures_path

      # Returns root folder for the project, of if one is missing it tries to return
      # Rails.root, if Rails is not defined it will raise an error.
      def root
        @root ||= begin
          if defined?(Rails)
            File.join Rails.root
          else
            "./"
          end
        end
      end
    end

    attr_reader :profile, :options, :fixtures_path
    
    def initialize path_to_config
      @config_path = File.expand_path path_to_config, self.class.root
      @profile, @options = Cockroach::Config::Loader.parse(@config_path)
      @fixturer_def = get_option('fixturer') || self.class.fixturer || 'factory_girl'
      @fixtures_path = self.class.fixtures_path if self.class.fixtures_path
    end

    def fixturer
      @fixturer ||= @fixturer_def.to_s.camelize.to_sym
    end

    def profiler
      @profiler ||= begin
        Cockroach.const_get(fixturer)::Profiler.new
      end
    end

    protected

    # Options might not be specified at all. In that case @options will be nil
    # This method will return nil, if option unavailable
    def get_option option
      @options[option.to_s] rescue nil
    end
  end
end