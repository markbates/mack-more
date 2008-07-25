module Mack
  module Data
    module Factory      
      
      # make sure the data factory API is available to the class that includes it
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        
        def create(num, scope = :default)
          factory_name = self.name.underscore
          model_name = factory_name.gsub('_factory', '')
          puts "creating #{num} instances of #{model_name.camelcase}"
          
          scoped_fields = field_manager.scopes[scope]
          fields = field_manager.scopes[:default].merge(scoped_fields)
          
          num.times do |i|
            obj = model_name.camelcase.constantize.new
            
            fields.each_pair do |k, v|
              field_name = k.to_s
              field_value = v.get_value
              assert_method(obj, "#{field_name}=", "#{model_name.camelcase} doesn't have #{field_name}= method!") do
                obj.send("#{field_name}=", field_value)
              end
            end
            
            assert_method(obj, "save", "#{model_name.camelcase} doesn't have save method.  Data will not be saved!") do
              obj.save
            end
          end
        end
        
        def field(model_attrib_sym, default_value, options = {})
          field_manager.add(scope, model_attrib_sym, default_value, options)
        end
        
        def scope_for(tag)
          set_scope(tag)
          yield
          set_scope(:default)
        end
        
        private
        
        def scope
          @current_scope ||= :default
          return @current_scope
        end
        
        def set_scope(tag)
          @current_scope = tag
        end
        
        def field_manager
          @fm ||= Mack::Data::FieldMgr.new
          return @fm
        end
        
        def assert_method(obj, meth, message)
          raise "#{self.name}: assert_method: no block given" if !block_given?
          if !obj.respond_to?(meth)
            Mack.logger.warn(message)
          else
            yield
          end
        end
        
      end
      
    end
  end
end
