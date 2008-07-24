module Mack
  module Data
    module Factory
      
      class Field
        attr_accessor :field_name
        attr_accessor :field_rules
      end
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        
        def create(num)
          factory_name = self.class.name.underscore
          model_name = factory_name.gsub('_factory', '')
          puts "creating #{num} instances of #{model_name.camelcase}"
        end
        
        def field(model_attrib_sym, default_value, options = {})
          
        end
        
      end
      
    end
  end
end
