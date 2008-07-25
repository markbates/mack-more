module Mack
  module Data    
    class Field
      attr_accessor :field_name
      attr_accessor :field_value
      attr_accessor :field_value_producer
      attr_accessor :field_rules
      
      def initialize(hash = {})
        puts "Inititalizing DataFactory's Field object:"
        hash.each_pair do |k, v|
          puts "--> Setting #{v} to #{k}"
          self.send("#{k}=", v)
        end
      end
      
      def get_value
        # must generate random string and also respect the rules
        return field_value
      end
    end
    
    class FieldMgr
      attr_reader :scopes
      
      def initialize
        @scopes = {}
      end
      
      def add(scope, field_name, default_value, options = {})
        field_list = fields(scope)
        field_list[field_name] = Field.new(:field_name  => field_name, 
                                            :field_value => default_value, 
                                            :field_rules => options)
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