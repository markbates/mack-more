module DataMapper # :nodoc:
  module Validate # :nodoc:
    class GenericValidator # :nodoc:

      def ==(other)
        self.field_name == other.field_name &&
        self.if_clause == other.if_clause &&
        self.class == other.class &&
        self.unless_clause == other.unless_clause &&
        self.instance_variable_get(:@options) == other.instance_variable_get(:@options)
      end

    end # class GenericValidator
  end # module Validate
end # module DataMapper
