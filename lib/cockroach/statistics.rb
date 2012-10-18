module Cockroach
  class Statistics
    attr_reader :profiler

    class << self
      def table_length
        %x{tput cols}.to_i rescue 80
      end
    end

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
#{"*"*table_length}
* #{"Cockroarch statistics".ljust(table_length-4)} *
#{"="*table_length}
HEADER
    end

    def footer
      "*"*table_length
    end

    def line_for_node node, level
      pure_space = table_length - 10
      amount_column_lenght = pure_space / 5
      node_name_column_lenght = (pure_space - amount_column_lenght) / 2
      source_column_length = pure_space - amount_column_lenght - node_name_column_lenght
      "* " << node.node_name.rjust(level).ljust(node_name_column_lenght) << " * " <<
        string_for_source(node.source).ljust(source_column_length) << " * " <<
        node.generated_amount.to_s.rjust(amount_column_lenght) << " *"
    end

    def table_length
      @table_length ||= self.class.table_length
    end

    def string_for_source s
      if s && (source = s.source)
        source.kind_of?(Cockroach::Base::Node) ?
          "Node(#{source.node_name})" :
          "Model(#{source.to_s})"
      else
        ''
      end
    end
  end
end