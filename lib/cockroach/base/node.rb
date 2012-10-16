require "cockroach/base/node_structure"

module Cockroach
  module Base
    # Node deals only with a specific records class. It makes sure that
    # fixtures are created specific amount of time and will make sure that
    # the associations are correctly assigned.
    class Node
      include Cockroach::Base::LoadNodes
      include Cockroach::Base::NodeStructure
      
      APPROACHES = %w(amount ratio).freeze

      class << self
        # Method validating structure for Node operations.
        # It will only accepts a structure if it is a Hash object,
        # with one key only.
        # In any other case a _false_ value will be returned
        def valid_structure? structure
          structure.is_a?(Hash) && structure.keys.size == 1 ||
            structure.is_a?(Array) && structure.size == 2
        end

        # Deduct the information from Node instance name:
        # will try to get:
        #   name: compulsary
        #   approach: optional
        # Returns array containing name and approach
        #
        # Example:
        #
        #   # no apprach
        #   ["users", nil]
        #
        #   # ratio apprach
        #   ["users", "ratio"]
        def extract_info symbol_or_string
          symbol_or_string = symbol_or_string.to_s
          approach = (symbol_or_string.match(/_(#{APPROACHES.join('|')})$/)[1] rescue nil)
          symbol_or_string.gsub!(/(_#{APPROACHES.join('|_')})$/,'') unless approach.blank?
          [symbol_or_string.to_s.singularize, approach]
        end
      end

      attr_reader :name, :approach, :ids, :source, :generated_amount

      delegate :find, :sample, :to => :source

      def initialize *opts
        node_name, @structure, @options = extract_params_from_attrs *opts
        @name, @approach = self.class.extract_info(node_name.dup)
        @ids = []
        @source = define_source if @structure.is_a?(Hash)
        @generated_amount = 0

        if @approach.blank?
          extract_options
          complicated_approch
          load_nodes
        else
          simple_approach
        end

        raise InvalideStructureError.new("Approch was not specified") if @approach.blank?
        raise MissingFixtureError.new("Approch was not specified") if @approach.blank?
        
        after_initialize
      end

      # Just in case Fixturer requires anything to be done after the node initialization
      def after_initialize
      end

      # Keeps the number, that represents the amount of the records that will
      # created for this node.
      # This will be the final number of the records that are going to be created.
      # In case there was a ratio specified, that method will randomly get a
      # number within the provided range and keep it.
      def amount
        @amount || get_random_amount
      end

      # Returns an aliased node name. The one that will be used for keeping it
      # in sup and sub structures
      def node_name
        @alias_as || @name
      end

      protected

      # There are four possible options here
      #  - structure
      #  - node_name, structure
      #  - structure, options
      #  - node_name, structure, options
      def extract_params_from_attrs *attrs
        structure = if attrs.size == 1 
          attrs.first
        elsif attrs.size == 3
          options = attrs.pop
          attrs
        else
          options = attrs.pop if attrs.first.is_a?(Hash)
          attrs
        end

        raise InvalideStructureError.new("Node has faced invalid structure") unless self.class.valid_structure?(structure)
        structure.flatten << (options || {})
      end

      # Complicated approach is used, once the amount directives were specified
      # within node subconfig.
      def complicated_approch
        approach = @options.select { |k,v| APPROACHES.include? k }
        raise InvalideStructureError.new("Amount is not specified or specified multiple times") unless approach.keys.size == 1
        case (@approach = approach.keys[0])
        when "amount"
          @amount = @options[@approach].to_i
        when "ratio"
          @options[@approach].is_a?(String) || @options[@approach].kind_of?(Numeric) ?
            set_simple_limits(@options[@approach].to_i) :
            extract_limits(@options[@approach])
        end
      end

      # Simple approach is used when the amount of the records is specified as the
      # Yaml node content, and the way this number should be treated as a node
      # suffix 
      def simple_approach
        case @approach
        when "amount"
          @amount = @structure.to_i
        when "ratio"
          set_simple_limits @structure.to_i
        end
      end

      # Clear the node subconfig. Will extract all the options or directives from
      # provided Hash, and assigne the to the corresponding variables.
      def extract_options
        @options.merge! @structure.extract!(*APPROACHES).delete_if {|k,v| v.nil?}
        @alias_as = @structure.delete("as")
        @structure.each_pair {| key, value | (@aliases ||= {})[$1] = value if key =~ /^(.*)_as$/ }
        @structure.delete_if {| key, value | key =~ /_as$/ }
      end

      # Defines a simple limits for random amount. It is as simple as
      #   lowest possible value a half of middle_line
      #   highest value is twice the middle_line
      def set_simple_limits middle_line
        @upper_limit, @lower_limit = [middle_line / 2, middle_line * 2]
      end

      def extract_limits hash
        @upper_limit, @lower_limit = [hash['lower_limit'].to_i, hash['upper_limit'].to_i]
      end

      # Returns manimum and minumum options within an array, for the amount of
      # the records, that will be used to generate the amount of the records
      # that will created for this node.
      #
      # Example:
      #
      #   [5, 12]
      def get_limits
        [@upper_limit, @lower_limit]
      end

      # Generates the number, that represents the amount of the records that will
      # created for this node.
      def get_random_amount
        min, max = get_limits

        if max - min > 0
          min + Random.rand(max - min)
        else
          min
        end
      end

      # Returns orm class deducted from fixturer
      def orm_class
        raise "Implement"
      end

      def define_source
        source_refs = @structure.delete('source')
        return unless source_refs
        Cockroach::Source.get_source source_refs
      end
    end
  end
end