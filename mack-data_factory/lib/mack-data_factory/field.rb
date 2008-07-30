module Mack
  module Data
    
    class Field
      attr_accessor :field_name
      attr_accessor :field_value
      attr_accessor :field_value_producer
      attr_accessor :field_rules

      def initialize(hash = {})
        #puts "Inititalizing DataFactory's Field object:"
        
        hash.each_pair do |k, v|
          #puts "--> Setting #{v} to #{k}"
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
      
      def get_value(index = 0)
        # return the field_value immediately if the rule states that it's immutable
        return field_value if field_rules[:immutable]
        
        # 
        # if the value is a hash, then it's a relationship mapping
        if field_value.is_a?(Hash)
          owner = field_value.keys[0]
          key   = field_value[owner]
          begin
            owner_model = owner.to_s.camelcase.constantize
            bridge = Mack::Data::Bridge.new
            value = bridge.get_first(owner_model).send(key)
            return value
          rescue Exception
            Mack.logger.warn "WARNING: DataFactory: field_value for #{field_name} is not set properly because data relationship defined is not correct"
          end
        end
        
        # must generate random string and also respect the rules
        field_value_producer.call(field_value, field_rules, index)
      end
    end
  end
end
