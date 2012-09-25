module Cockroach
  module Base
    module LoadNodes
      def load_nodes
        @structure.each do |a|
          (@nodes ||= []) << Cockroach::FactoryGirl::Node.new(a)
        end
      end
    end
  end
end