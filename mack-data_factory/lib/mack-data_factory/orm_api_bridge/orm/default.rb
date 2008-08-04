module Mack
  module Data
    module OrmBridge
      class Default
        
        def can_handle(obj)
          return true
        end
        
        def get(obj, *args)
          Mack.logger.warn "Mack::Data::OrmBridge: You don't have supported orm api handler installed."
        end
        
        def get_all(obj, *args)
          Mack.logger.warn "Mack::Data::OrmBridge: You don't have supported orm api handler installed."
        end
        
        def count(obj, *args)
          Mack.logger.warn "Mack::Data::OrmBridge: You don't have supported orm api handler installed."
        end
        
        def save(obj, *args)
          Mack.logger.warn "Mack::Data::OrmBridge: You don't have supported orm api handler installed."
        end
        
        def get_first(obj, *args)
          Mack.logger.warn "Mack::Data::OrmBridge: You don't have supported orm api handler installed."
        end
        
        
      end
    end
  end
end
