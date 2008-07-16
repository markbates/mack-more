module DataMapper # :nodoc:
  module Validate # :nodoc:

    class ConfirmationValidator < GenericValidator # :nodoc:

      def valid?(target)
        field_value = target.instance_variable_get("@#{@field_name}")
        return true if @options[:allow_nil] && field_value.nil?
        return false if !@options[:allow_nil] && field_value.nil?
        return true unless target.attribute_dirty?(@field_name)

        confirm_value = target.instance_variable_get("@#{@confirm_field_name}")
        field_value == confirm_value
      end

    end # class ConfirmationValidator

  end # module Validate
end # module DataMapper
