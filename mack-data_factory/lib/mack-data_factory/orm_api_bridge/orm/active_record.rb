module Mack
  module Data
    module OrmBridge
      class ActiveRecord
        
        def can_handle(obj)
          return false if !Object.const_defined?('ActiveRecord')
          return obj.ancestors.include?(::ActiveRecord::Base)
        end
        
        def get(obj, *args)
          obj.find(*args)
        end
        
        def count(obj, *args)
          obj.count(*args)
        end
        
        def save(obj, *args)
          obj.save
        end
        
        def get_first(obj, *args)
          obj.find(:first, *args)
        end
        
      end
    end
  end
end
