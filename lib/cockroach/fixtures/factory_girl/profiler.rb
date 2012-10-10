require "cockroach/base/node_structure"

module Cockroach
  module FactoryGirl
    # Profiler does all the routine to fill the database.
    class Profiler
      include Cockroach::Base::LoadNodes
      include Cockroach::Base::NodeStructure
      
      def initialize config = Cockroach.config
        @source = config.profile
        @base_models = @source.keys
      end

      # This method will load all the mentioned records into database
      def load
        unless @loaded
          Cockroach::FactoryGirl::Loader.load
          @source.each_pair do |name, structure|
            node = Cockroach::FactoryGirl::Node.new(name, structure)
            nodes[node.node_name] = node
          end
          @loaded = true
        end
      end

      # This method will load all the mentioned records into database
      def load!
        load unless @loaded
        nodes.each_value(&:load!)
      end
    end
  end
end