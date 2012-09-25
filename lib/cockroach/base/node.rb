module Cockroach
  module Base
    # Node deals only with a specific records class. It makes sure that
    # fixtures are created specific amount of time and will make sure that
    # the associations are correctly assigned.
    class Node
      
      APPROACHES = %w(amount ratio).freeze

      class << self
        # Method validating structure for Node operations.
        # It will only accepts a structure if it is a Hash object,
        # with one key only.
        # In any other case a _false_ value will be returned
        def valid_structure? structure
          structure.is_a?(Hash) && structure.keys.size == 1
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
          [symbol_or_string, approach]
        end
      end

      attr_reader :name, :approach, :factory # :amount

      def initialize structure
        raise InvalideStructureError.new("Node has faced invalid structure") unless self.class.valid_structure?(structure)
        @node_key, @structure = structure.flatten
        @name, @approach = self.class.extract_info(@node_key.dup)
        @approach.blank? ? complicated_approch : simple_approach
        raise InvalideStructureError.new("Approch was not specified") if @approach.blank?
        raise MissingFixtureError.new("Approch was not specified") if @approach.blank?
        @factory = ::FactoryGirl.factory_by_name(@name)
      end

      # This method will load all the mentioned records into the database
      def load
        raise "Abstract method"
      end

      # Keeps the number, that represents the amount of the records that will
      # created for this node.
      def amount
        @amount ||= get_random_amount
      end

      protected

      def complicated_approch
        approach = @structure.select { |k,v| APPROACHES.include? k }
        raise InvalideStructureError.new("Amount is not specified or specified multiple times") unless approach.keys.size == 1
        case (@approach = approach.keys[0])
        when "amount"
          @amount = @structure[@approach].to_i
        when "ratio"
          @structure[@approach].is_a?(String) ?
            set_simple_limits(@structure[@approach].to_i) :
            extract_limits(@structure[@approach])
        end
      end

      # DEf
      def simple_approach
        case @approach
        when "amount"
          @amount = @structure.to_i
        when "ratio"
          set_simple_limits @structure.to_i
        end
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
    end
  end
end