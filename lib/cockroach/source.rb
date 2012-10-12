module Cockroach
  module Source
    autoload :Base, 'cockroach/source/base'
    autoload :Node, 'cockroach/source/node'
    autoload :Model, 'cockroach/source/model'

    class << self
      def get_source source_refs
        return unless source_refs
        if source_refs.is_a?(Hash) && source_refs.keys.include?('model')
          get_model source_refs
        else
          get_node source_refs
        end
      end

      protected

      def get_model source_refs
        model_name = source_refs.delete('model')
        Cockroach::Source::Model.new model_name.to_s.constantize, source_refs
      end

      def get_node source_refs
        if source_refs.is_a?(String)
          source_path, options = [source_refs], {}
        else
          options = source_refs.extract!("association")
          source_path = source_refs.flatten
          while source_path.last.is_a? Hash
            source_path << source_path.pop.flatten
          end
        end
        source_path.flatten!
        node = source_path.inject(::Cockroach.profiler) do |node_keeper, node_name|
          node_keeper[node_name]
        end
        Cockroach::Source::Node.new node, options
      end
    end
  end
end