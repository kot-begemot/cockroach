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
        factory_name = name.singularize
        
        if factory_opts
          normalised_opts = factory_opts.dup
          @aliases.each_pair { |k,v| normalised_opts[k] = normalised_opts.delete(v) } if @aliases
          normalised_opts.keep_if {|k,v| allowed_options.include? k }
        end
        
        amount.times do
          current_factory = normalised_opts ?
            ::FactoryGirl.create(factory_name, normalised_opts) :
            ::FactoryGirl.create(factory_name)
          unless nodes.blank?
            load_nodes! (factory_opts || {}).merge({ (@alias_as || factory_name) => current_factory})
          end
        end
      end

      protected

      def allowed_options
        @allowed_options ||= @factory.send(:evaluator_class).attribute_list.names
      end
    end
  end
end