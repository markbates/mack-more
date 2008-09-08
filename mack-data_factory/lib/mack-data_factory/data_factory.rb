module Mack # :nodoc:
  module Data # :nodoc:
    #
    # Add factory capability to a class.
    # 
    # A factory is able to define which field it want to generate content for,
    # define a scope for different situation, and set a custom content generator 
    # for field that doesn't want to use the default content generator.
    #
    # For more information and usage, please read README file
    #
    # Author:: Darsono Sutedja
    # Date:: July 2008
    #
    module Factory      
      
      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end
      
      module ClassMethods
        
        #
        # Run the factory to produce n number of objects.
        #
        # <i>Example:</i>
        # 
        #   class CarFactory
        #     include Mack::Data::Factory
        #     field :name, :default => "honda" { |def_value, rules, index| "#{def_value} #{['civic', 'accord', 'pilot'].randomize[0]}"}
        #   end
        # 
        #   CarFactory.create(100) #=> will produce 100 cars whose name is "honda xxx" where xxx is a random item from ['civic', 'accord', 'pilot']
        # 
        # <i>Parameters:</i>
        #   num:  how many objects to produce
        #   scope:  run the factory in a named scope.  By default the factory will be run in _default_ scope
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
          Mack::Data::RegistryMap.reset!
          
          return ret_arr[0] if ret_arr.size == 1
          return ret_arr
        end
        
        #
        # Define a field for the factory class, and set the name of the field,
        # any options for the field, and optionally specify a block that serves as the custom 
        # content generator.
        #
        # The options can be categorized into the following:
        # * default value (e.g. :default_value => "foo")
        # * whether it's immutable or not (e.g. :immutable => true, and by default it's false)
        # * the field's content type (e.g. :content => :alpha)
        # * and the rules on how to generate the content (rules are contextually dependent on the content type).
        #
        # The following are all the supported content types and its rules:
        # 
        # <i>Strings and Numbers</i>
        # * :alpha --> alphabets.  rules: [:length, :min_length, :max_length]
        # * :alphanumeric --> alphabets and number.  rules: same as :alpha
        # * :numeric --> numbers [optional, because if the field's default value is number, its content type will automatically set to numeric)
        # <i>Time and Money</i>
        # * :time --> generate random time object.  rules: [:start_time, :end_time].  It will generate random time between the given start and end time if available, otherwise it'll generate random time between 'now' and 1 day from 'now'
        # * :money --> generate random amount of money. rules: [:min, :max].  It will generate random money amount (of BigDecimal type) between the given min and max amount.
        # <i>Internet related content</i>
        # * :email --> generate random email address
        # * :username --> generate random username
        # * :domain --> generate random domain name
        # <i>Name related info</i>
        # * :firstname --> generate first name
        # * :lastname --> generate last name
        # * :name --> generate full name
        # <i>Address related info</i>
        # * :city --> generate city name
        # * :streetname --> generate street name
        # * :state --> generate state.  rules: [:country --> :us or :uk, :abbr --> true if you want a abbreviated state name (us only)]
        # * :zipcode --> generate zipcode. rules: [:country --> :us or :uk]
        # * :phone --> generate phone number
        # <i>Company info</i>
        # * :company --> generate company name.  rules: [:include_bs --> include sales tag line]
        #   example:  field, :content => :company, :include_bs => true
        #   could generate something like:
        #       Fadel-Larkin
        #       monetize cross-media experiences
        #
        # <i>Parameters:</i>
        #  model_attrib_sym: the name of the field
        #  options: the options for the field.  
        #  block: the optional custom content generator
        #
        def field(model_attrib_sym, options = {}, &block)
          field_manager.add(scope, model_attrib_sym, options, &block)
        end
        
        # 
        # Define an association rule for this field.
        #
        # <i>Example:</i>
        #   class ItemFactory
        #     include Mack::DataFactory
        #     ...
        #     association :owner_id, {:user => 'id'}, :random
        #   end
        #   
        # The above example states that for each item generated, its owner_id will
        # come from user's id field. But which user?  since the association rule
        # is set to random, then the generator will pick random user.
        #
        # <i>Supported association rules: </i>
        #   :first:: If there are 10 users, then the item will get associated with user #0.
        #   :last:: If there are 10 users, then the item will get associated with user #10.
        #   :random:: If there are 10 users, then the item will get associated with user #rand(10)
        #   :spread:: If there are 3 users, then the items' association will be spread out (i.e. 6 items will have id, sequentially, [0, 1, 2, 0, 1, 2])
        #
        # <i>Parameters:</i>
        #   model_attrib_sym: the name of the field
        #   assoc_map: the association map
        #
        def association(model_attrib_sym, assoc_map, assoc_rule = :spread)
          field(model_attrib_sym, {:default => {:df_assoc_map => assoc_map}, :assoc => assoc_rule})
        end
        
        # 
        # Define a scope in the factory.
        # Any field defined in a scope will overwrite its sibling in the default scope.
        #
        # <i>Parameters:</i>
        #   tag: name of the scope
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
