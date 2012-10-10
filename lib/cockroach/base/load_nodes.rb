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
          @structure.each do |name, structure|
            node = Cockroach::FactoryGirl::Node.new(name, structure, {:parrent => self})
            nodes[node.node_name] = node
          end
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