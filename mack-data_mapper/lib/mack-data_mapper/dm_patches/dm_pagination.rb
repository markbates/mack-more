module DataMapper # :nodoc:
  module Is # :nodoc:
    module Paginated # :nodoc:
      
      def is_paginated(options = {}) # :nodoc:
        extend DataMapper::Is::Paginated::ClassMethods
      end
 
      module ClassMethods # :nodoc:
        
        def paginated(options = {})
          page     = (options.delete(:page) || 1).to_i
          per_page = (options.delete(:per_page) || 5).to_i
          
          order_clause = options.delete(:order) || []
    
          page_count = (count(options).to_f / per_page).ceil
          
          key.each do |k| 
            order_clause << k.name.to_sym.asc
          end
          
          options.reverse_merge!({
            :order => order_clause
          })
          
          offset = (page - 1) * per_page
          offset = 0 if offset < 0
          
          options.merge!({
            :limit => per_page, 
            :offset => offset
          })

          [ page_count , all(options) ]
        end
        
      end # ClassMethods
      
    end # Paginated
  end # Is
  
  module Resource # :nodoc:
    module ClassMethods # :nodoc:
      include DataMapper::Is::Paginated
    end # module ClassMethods
  end # module Resource
  
end # DataMapper