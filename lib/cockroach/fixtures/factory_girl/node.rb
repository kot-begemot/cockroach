module Cockroach
  module FactoryGirl
    # Node deals only with a specific records class. It makes sure that
    # fixtures are created specific amount of time and will make sure that
    # the associations are correctly assigned.
    class Node < ::Cockroach::Base::Node
      def after_initialize
        @factory = ::FactoryGirl.factory_by_name(@name)
      end

      def load!
        ::FactoryGirl
      end
    end
  end
end