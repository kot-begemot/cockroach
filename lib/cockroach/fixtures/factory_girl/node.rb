module Cockroach
  module FactoryGirl
    # Profiler does all the routine to fill the database.
    class Node

      APPROACHES = %w(amount ratio).freeze

      class InvalideStructureError < Exception; end
      class MissingNodeError < Exception; end

      class << self
        # Method validating structure for Node operations.
        # It will only accepts a structure if it is a Hash object,
        # with one key only.
        # In any other case a _false_ value will be returned
        def valid_structure? structure
          structure.is_a?(Hash) && structure.keys.size == 1
        end

        # Deduct the name of the Node instance from provided sting.
        def extract_name symbol_or_string
          row = "#{symbol_or_string}".match(/^(.*)(?:_#{APPROACHES.join('|_')})$/)
          row[1]
        end
      end

      attr_reader :name

      def initialize structure
        raise InvalideStructureError.new("Node has faced invalid structure") unless self.class.valid_structure?(structure)
        @name = self.class.extract_name(structure.keys[0])
      end

      # This method will load all the mentioned records into database
      def load

      end

      # Keeps the number, that represents the amount of the records that will
      # created for this node.
      def amount
        @amount ||= get_random_amount
      end

      protected

      # Returns manimum and minumum options within an array, for the amount of
      # the records, that will be used to generate the amount of the records
      # that will created for this node.
      # 
      # Example:
      #
      #   [5, 12]
      def get_limits

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