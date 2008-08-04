module Mack
  module Data
    
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
      
      def get_all(obj, *args)
        handler(obj).get_all(obj, *args)
      end
      
      def get_first(obj, *args)
        handler(obj).get_first(obj, *args)
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
