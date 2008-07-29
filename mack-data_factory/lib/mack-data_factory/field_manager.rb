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
        
        self.field_rules = {
          :immutable => false,
          :length => 256,
          :add_space => true,
          :content => :alpha_numeric,
          :null_frequency => nil
        }.merge!(hash[:field_rules]) if hash[:field_rules] != nil
        
        # transform the content type based on the given default value
        if field_value.is_a?(Fixnum) or field_value.is_a?(Integer)
          field_rules[:content] = :numeric
        end
        
        self.field_value_producer = Mack::Data::Factory::FieldContentGenerator.send("#{field_rules[:content]}_generator")
      end
      
      def get_value
        # return the field_value immediately if the rule states that it's immutable
        return field_value if field_rules[:immutable]
        
        if field_value.is_a?(Hash)
          owner = field_value.keys[0]
          key   = field_value[owner]
          begin
            owner_model = owner.to_s.camelcase.constantize
            bridge = Mack::Data::Bridge.new
            self.field_value = (bridge.get(owner_model, rand(bridge.count(owner_model)))).send(key)
            return self.field_value
            #self.field_value = owner_model.get(rand(owner_model.count)).send(key)
          rescue Exception
            Mack.logger.warn "WARNING: DataFactory: field_value for #{field_name} is not set properly because data relationship defined is not correct"
          end
        end
        
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