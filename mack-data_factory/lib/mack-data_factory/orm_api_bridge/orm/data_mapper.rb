module Mack
  module Data
    module OrmBridge
      class DataMapper
        
        def can_handle(obj)
          return false if !Object.const_defined?('DataMapper')
          return obj.ancestors.include?(::DataMapper::Resource)
        end
        
        def get(obj, *args)
          obj.get(*args)
        end
        
        def count(obj, *args)
          obj.count(*args)
        end
        
        def save(obj, *args)
          obj.save
        end
        
        def get_first(obj, *args)
          obj.first(*args)
        end
        
      end
    end
  end
end
