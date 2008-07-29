module Mack
  module Data          
    class FieldMgr
      attr_reader :scopes
      
      def initialize
        @scopes = {}
      end
      
      def add(scope, field_name, default_value, options = {}, &block)
        field_list = fields(scope)
        field_list[field_name] = Field.new(:field_name  => field_name, 
                                            :field_value => default_value, 
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