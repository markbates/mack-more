module Mack
  module Data
    
    #
    # Registry list (LIFO) for all valid handlers.
    #
    # <i>Example:</i>
    # OrmRegistry.add(Mack::Data::OrmBridge::ActiveRecord.new)
    #
    class OrmRegistry < Mack::Utils::RegistryList
    end
    
    #
    # Different ORMs have different API at getting object from the store.
    # The ORM bridge is an attempt to have a common API that the data_factory
    # can use to get at the objects it needed.  
    # 
    # Currently there are 2 orm bridges implemented: DataMapper and ActiveRecord.
    # But developers are free to develop another adapter.
    #
    # Although this feature is called an "ORM" bridge, the API that it's trying
    # to bridge doesn't necessarily have to be of an ORM.  As long as the module
    # you're bridging can respond to these API, you can use it as a valid adapter.
    # 
    # This feature is an advanced feature of the Data Factory, and it's very useful
    # in a case where you have some legacy data sitting somewhere, or you may have
    # a collection of data that is obtained through a very costly sql query (so doing
    # it many times is obviously not acceptable).  So you may want to build a class
    # that can preload all the data, then register itself to the OrmRegistry.
    #
    # The most important method that a "handler" must implement is the can_handle
    # method.  When the DataFactory is handling a certain object, it will attempt
    # to find the appropriate API module that can handle that object, so it will
    # ask all the registered handlers of the OrmRegistry, and the first one to
    # answer yes to the question will be the handler of the object.
    # When a handler say yes to the question, it's expected that the handler
    # implement all the methods defined in the Bridge class.
    #
    class Bridge
      
      def initialize
        OrmRegistry.add(Mack::Data::OrmBridge::ActiveRecord.new)
        OrmRegistry.add(Mack::Data::OrmBridge::DataMapper.new)
      end
      
      # 
      # Get a record from the given _obj_ model.
      # In active record implementation: this will get translated to
      # obj.find(*args)
      #
      # <i>Parameters:</i>
      #   obj: the object model class
      #   args: the list of arguments
      #
      def get(obj, *args)
        handler(obj).get(obj, *args)
      end
      
      #
      # Get all records from the given _obj_ model
      #
      # <i>Parameters:</i>
      #   obj: the object model class
      #   args: the list of arguments
      #
      def get_all(obj, *args)
        handler(obj).get_all(obj, *args)
      end
      
      #
      # Get the first record from the given _obj_ model
      #
      # <i>Parameters:</i>
      #   obj: the object model class
      #   args: the list of arguments
      #
      def get_first(obj, *args)
        handler(obj).get_first(obj, *args)
      end
      
      # Get the total number of records for the given _obj_ model
      #
      # <i>Parameters:</i>
      #   obj: the object model class
      #   args: the list of arguments
      #
      def count(obj, *args)
        handler(obj).count(obj, *args)
      end
      
      #
      # Commit changes made to the _obj_ model
      #
      # <i>Parameters:</i>
      #   obj: the object model class
      #   args: the list of arguments
      #
      def save(obj, *args)
        handler(obj).save(obj, *args)
      end
      
      private 
      def handler(obj)
        OrmRegistry.registered_items.each do |i|
          if i.can_handle(obj)
            return i
          end
        end
        return Mack::Data::OrmBridge::Default.new
      end
      
    end
  end
end
