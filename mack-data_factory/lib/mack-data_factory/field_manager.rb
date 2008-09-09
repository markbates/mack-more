module Mack
  module Data          
    class FieldMgr # :nodoc:
      attr_reader :scopes
      
      def initialize
        @scopes = {}
      end
      
      def add(scope, field_name, options = {}, &block)
        #default_value = options[:default] || ""
        field_list = fields(scope)
        field_list[field_name] = Field.new( :field_name  => field_name, 
                                            :field_rules => options)
        field_list[field_name].field_value_producer = block if block_given?
        return field_list
      end
      
      def fields(scope = :default)
        if @scopes[scope].nil?
          @scopes[scope] = {} 
        end
        return @scopes[scope]
      end
  
    end
  end
end