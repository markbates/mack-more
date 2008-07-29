module Mack
  module Data
    
    # use list
    # for each api bridge, it must answer "can_handle(obj)" correctly
    # the first one that answers true to that method is the handler!
    class OrmRegistry < Mack::Utils::RegistryList
    end
    
    class Bridge
      
      def initialize
        OrmRegistry.add(Mack::Data::OrmBridge::ActiveRecord.new)
        OrmRegistry.add(Mack::Data::OrmBridge::DataMapper.new)
      end
      
      def get(obj, *args)
        handler(obj).get(obj, *args)
      end
      
      def count(obj, *args)
        handler(obj).count(obj, *args)
      end
      
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
