module Cockroach
  class Statistics
    attr_reader :profiler
    TABLE_LENGTH = 50

    def initialize(profiler = nil)
      @profiler = profiler || Cockroach.profiler
    end

    def print_stats!
      puts header
      profiler.nodes.each_value do |subnode|
        print_sub_nodes subnode, 0
      end
      puts footer
    end
    
    protected

    def print_sub_nodes node, level = 0
      puts line_for_node node, level
      unless node.nodes.blank? 
        node.nodes.each_value do |subnode|
          print_sub_nodes subnode, level + 1
        end
      end
    end

    private

    def header
      <<HEADER
      #{"*"*TABLE_LENGTH}
      * #{"Cockroarch statistics".ljust(TABLE_LENGTH-4)} *
      #{"="*TABLE_LENGTH}
HEADER
    end

    def footer
      "*"*TABLE_LENGTH
    end

    def line_for_node node, level
      "* " << node.node_name.rjust(level).ljust(TABLE_LENGTH - 30) << " * " <<
        string_for_source(node.source).ljust(15) << " * " << node.generated_amount.to_s.rjust(5) << " *"
    end

    def string_for_source s
      if s && (source = s.source)
        source.kind_of?(Cockroach::Base::Node) ?
          "Node(#{source.node_name})" :
          "Model(#{source.display_name})"
      else
        ''
      end
    end
  end
end