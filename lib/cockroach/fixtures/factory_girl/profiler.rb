module Cockroach
  module FactoryGirl
    # Profiler does all the routine to fill the database.
    class Profiler
      def initialize config = Cockroach.config
        @source = config.profile
        @base_models = @source.keys
        
      end

      # This method will load all the mentioned records into database
      def load

      end
    end
  end
end