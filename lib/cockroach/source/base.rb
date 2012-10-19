module Cockroach
  module Source
    class Base
      attr_reader :source

      def initialize model, options = {}
        @source = model
        @options = options
      end

      # Returns a random record, among generated.
      def sample
        instance = get_sample
        return get_association(instance) if association_as_source?
        instance
      end

      def association_as_source?
        @options.include?("association")
      end
      alias_method :association?, :association_as_source?

      def association_name
        @options["association"]
      end

      protected

      def get_sample
        raise "Abstract class"
      end

      def get_association instance
        instance.__send__(association_name)
      end
    end
  end
end