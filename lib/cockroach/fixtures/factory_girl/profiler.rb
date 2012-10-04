module Cockroach
  module FactoryGirl
    # Profiler does all the routine to fill the database.
    class Profiler
      include Cockroach::Base::LoadNodes
      
      def initialize config = Cockroach.config
        @source = config.profile
        @base_models = @source.keys
      end

      # This method will load all the mentioned records into database
      def load
        unless @loaded
          @source.each_pair do |name, structure|
            (@nodes ||= []) << Cockroach::FactoryGirl::Node.new(name, structure)
          end
          @loaded = true
        end
      end

      # This method will load all the mentioned records into database
      def load!
        load unless @loaded
        nodes.each(&:load!)
      end
    end
  end
end