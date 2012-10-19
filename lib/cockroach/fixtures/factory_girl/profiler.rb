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
          @source.each_pair do |factory_name, structure|
            if structure.kind_of? Array
              structure.each {|node_structure| load_node(factory_name, node_structure)}
            else
              load_node(factory_name, structure)
            end
          end
          @loaded = true
        end
      end

      # This method will load all the mentioned records into database
      def load!
        load unless @loaded 
        nodes.each_value(&:load!)
      end

      protected

      def load_node fixture_name, node_structure
        node = Cockroach::FactoryGirl::Node.new(fixture_name, node_structure)
        nodes[node.node_name] = node
      end
    end
  end
end