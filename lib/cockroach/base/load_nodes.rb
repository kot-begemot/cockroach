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

        protected

        # Parse structure file and create a branch of sub nodes.
        def load_nodes
          @structure.each do |node_structure|
            (@nodes ||= []) << Cockroach::FactoryGirl::Node.new(node_structure)
          end
        end

        # Load all the sub nodes
        def load_nodes! fixturer_opts = nil
          @nodes.each do |node|
            node.load! fixturer_opts
          end
        end
      end
    end
  end
end