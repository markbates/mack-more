module Mack
  module Database
    
    class Paginator
      
      def paginate
        order_clause = [self.options.delete(:order)].flatten.compact
          
        self.total_rows = self.klass.count(self.options)
        self.total_pages = (self.total_rows.to_f / self.results_per_page).ceil
        
        self.current_page = self.total_pages if self.current_page > self.total_pages
        
        if order_clause.empty?
          self.klass.key.each do |k| 
            order_clause << k.name.to_sym.asc
          end
        end

        self.options.reverse_merge!({
          :order => order_clause
        })
        
        offset = (self.current_page - 1) * self.results_per_page
        offset = 0 if offset < 0
        
        options.merge!({
          :limit => self.results_per_page, 
          :offset => offset
        })
        
        self.results = self.klass.all(options)
        self
      end # paginate
      
    end # Paginator
  end # Database
end # Mack

module DataMapper # :nodoc:
  module Resource # :nodoc:
    module ClassMethods # :nodoc:
      
      def paginate(options = {})
        paginator = Mack::Database::Paginator.new(self, options)
        paginator.paginate
      end
      
    end # ClassMethods
  end # Resource
end # DataMapper