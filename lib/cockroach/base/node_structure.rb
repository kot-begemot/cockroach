module Cockroach
  module Base
    # Simple idea. After that the nodes will be available as
    #   Cockroach::FactoryGirl::Node['top_node']['sub_mode']['sub_sub_node']
    module NodeStructure
      def [](name)
        (@nodes ||= {})[name.to_s]
      end
    end
  end
end