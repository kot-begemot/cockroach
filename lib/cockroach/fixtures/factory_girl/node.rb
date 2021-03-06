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
          normalised_opts.keep_if {|k,v| allowed_options.include? k }
        end

        times = amount
        @generated_amount += times
        times.times do
          current_factory = generate_current_factory(normalised_opts)
          ids << current_factory.id
          unless nodes.blank?
            load_nodes! (factory_opts || {}).merge({ node_name => current_factory})
          end
        end
      end

      protected
      
      def generate_current_factory options
        begin 
          if @source
            ret = @source.sample
            ret.update_attributes(options) unless options.blank?
            ret
          else
            options.blank? ?
              ::FactoryGirl.create(name) :
              ::FactoryGirl.create(name, options)
          end
        rescue
          puts "Exception occured during node evaliation: #{node_name}"
          raise $!
        end
      end

      def allowed_options
        @allowed_options ||= @factory.send(:evaluator_class).attribute_list.names.map(&:to_s)
      end

      # Returns class deducted from factory
      def orm_class
        @factory.send(:build_class)
      end
    end
  end
end