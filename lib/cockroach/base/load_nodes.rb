require 'active_support/concern'

module Cockroach
  module Base
    module LoadNodes
      extend ActiveSupport::Concern

      included do
        attr_reader :nodes

        def load! *agrs
          raise "Abstract method"
        end

        def nodes
          @nodes ||= {}
        end

        protected

        # Parse structure file and create a branch of sub nodes.
        def load_nodes
          @structure.each do |fixture_name, structure|
            if structure.kind_of? Array
              structure.each.map {|node_structure| load_node(fixture_name, node_structure)}
            else
              load_node(fixture_name, structure)
            end
          end
        end

        def load_node fixture_name, node_structure
          node = Cockroach::FactoryGirl::Node.new(fixture_name, node_structure, {:parrent => self})
          nodes[node.node_name] = node
        end

        # Load all the sub nodes
        def load_nodes! fixturer_opts = nil
          nodes.each_value do |node|
            node.load! fixturer_opts
          end
        end
      end
    end
  end
end