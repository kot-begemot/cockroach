module Cockroach
  module FactoryGirl
    # Node deals only with a specific records class. It makes sure that
    # fixtures are created specific amount of time and will make sure that
    # the associations are correctly assigned.
    class Node < ::Cockroach::Base::Node
      def after_initialize
        @factory = ::FactoryGirl.factory_by_name(@name)
      end

      def load! factory_opts = nil
        if factory_opts
          normalised_opts = factory_opts.dup
          @aliases.each_pair { |k,v| normalised_opts[k] = normalised_opts.delete(v) } if @aliases
        end
        amount.times do
          factory_name = name.singularize
          current_factory = factory_opts ? 
            ::FactoryGirl.create(factory_name, normalised_opts) :
            ::FactoryGirl.create(factory_name)
          unless nodes.blank?
            load_nodes! (factory_opts || {}).merge({ (@alias_as || factory_name) => current_factory})
          end
        end
      end
    end
  end
end