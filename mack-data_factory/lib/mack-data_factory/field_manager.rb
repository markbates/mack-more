module Mack
  module Data      
    class Field
      attr_accessor :field_name
      attr_accessor :field_value
      attr_accessor :field_value_producer
      attr_accessor :field_rules
      
      def initialize(hash = {})
        debugger
        puts "Inititalizing DataFactory's Field object:"
        
        hash.each_pair do |k, v|
          puts "--> Setting #{v} to #{k}"
          self.send("#{k}=", v)
        end
        
        self.field_rules = {
          :immutable => false,
          :length => 256,
          :add_space => true,
          :content => :alpha_numeric,
          :null_frequency => nil
        }.merge!(hash[:field_rules]) if hash[:field_rules] != nil
        
        self.field_value_producer = Mack::Data::Factory::FieldContentGenerator.send("#{field_rules[:content]}_generator")
        foo = "bar"
      end
      
      def get_value
        # return the field_value immediately if the rule states that it's immutable
        return field_value if field_rules[:immutable]
        
        # must generate random string and also respect the rules
        field_value_producer.call(field_value, field_rules)
      end
    end
    
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