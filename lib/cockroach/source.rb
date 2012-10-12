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

      # Many ways to provide reference to Node.
      # First is:
      #   just string
      # Next one is:
      #   hash with "node" key
      #   the value may be either hash or string
      # Or Just hash
      #
      # Possible options are:
      #   association
      def get_node source_refs
        if source_refs.is_a?(String)
          source_path, options = [source_refs], {}
        else
          options = source_refs.extract!("association").keep_if {|k,v| !v.blank?}
          source_path = source_refs.include?("node") ? source_refs.delete('node') : source_refs
          source_path = source_path.flatten if (source_path.is_a?(Hash))
          if source_path.is_a?(String)
            source_path = [source_path]
          else
            while source_path.last.is_a? Hash
              source_path << source_path.pop.flatten
            end
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