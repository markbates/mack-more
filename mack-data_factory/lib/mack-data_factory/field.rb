module Mack
  module Data
    
    class RegistryMap < Mack::Utils::RegistryMap
    end
    
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
            
            assoc_rules = field_rules[:assoc] || :spread
            assoc_rules = :random if !([:first, :last, :random, :spread].include?(assoc_rules))
            # cache the query once
            if Mack::Data::RegistryMap.registered_items[self.field_name.to_sym] == nil
              all_owner_models = bridge.get_all(owner_model)
              Mack::Data::RegistryMap.add(self.field_name.to_sym, all_owner_models)
            end
            
            all_owner_models = Mack::Data::RegistryMap.registered_items[self.field_name.to_sym][0]
            
            case assoc_rules
              when :first
                value = all_owner_models[0].send(key)
              when :last
                value = all_owner_models[bridge.count(owner_model)-1].send(key)
              when :random
                my_index = rand((all_owner_models.size - 1))
                value = all_owner_models[my_index].send(key)
              when :spread
                # if index >= all_owner_models.size 
                #   my_index = rand((all_owner_models.size - 1))
                # else
                #   my_index = index
                # end
                my_index = index % all_owner_models.size
                value = all_owner_models[my_index].send(key)
            end
            
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
