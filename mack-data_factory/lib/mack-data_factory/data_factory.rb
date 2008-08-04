module Mack
  module Data
    #
    # Add factory capability to a class.
    # 
    # A factory is able to define which field it want to generate content for,
    # define a scope for different situation, and set a custom content generator 
    # for field that doesn't want to use the default content generator.
    #
    # For more information and usage, please read README file
    #
    # author: Darsono Sutedja
    # July 2008
    #
    module Factory      
      
      # make sure the data factory API is available to the class that includes it
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        
        #
        # Run the factory to produce n number of objects.
        #
        # Example:
        # class CarFactory
        #    include Mack::Data::Factory
        #    field :name, "honda" { |def_value, rules, index| "#{def_value} #{['civic', 'accord', 'pilot'].randomize[0]}"}
        # end
        #
        # CarFactory.create(100) #=> will produce 100 cars whose name is "honda xxx" where xxx is a random item from ['civic', 'accord', 'pilot']
        #
        # params:
        # * num - how many objects to produce
        # * scope - run the factory in a named scope
        #
        def create(num, scope = :default)
          factory_name = self.name.underscore
          
          # retrieve the model name from the factory class. 
          model_name = factory_name.gsub('_factory', '')
          
          # if user is running custom scope, then merge the fields 
          # defined for that scope with the default one, before we run the factory
          scoped_fields = field_manager.scopes[scope]
          fields = field_manager.scopes[:default].merge(scoped_fields)
          
          ret_arr = []
          
          Mack::Data::RegistryMap.reset!
          num.times do |i|
            #puts "Creating #{model_name} ##{i+1}"
            obj = model_name.camelcase.constantize.new
            
            fields.each_pair do |k, v|
              field_name = k.to_s
              field_value = v.get_value(i)
              assert_method(obj, "#{field_name}=", "#{model_name.camelcase} doesn't have #{field_name}= method!") do
                obj.send("#{field_name}=", field_value)
              end
            end
            
            assert_method(obj, "save", "#{model_name.camelcase} doesn't have save method.  Data will not be saved!") do
              obj.save
            end
            
            ret_arr << obj
          end
          
          return ret_arr[0] if ret_arr.size == 1
          return ret_arr
        end
        
        #
        # Define a field with its default value and rules and an optional content generator
        # for this factory
        #
        def field(model_attrib_sym, default_value, options = {}, &block)
          field_manager.add(scope, model_attrib_sym, default_value, options, &block)
        end
        
        # 
        # Define a scope in the factory.
        # Any field defined in a scope will overwrite its cousin in the default scope.
        #
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
