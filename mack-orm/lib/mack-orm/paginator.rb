module Mack
  module Database
    
    def self.paginate(klass, options = {})
      paginator = Mack::Database::Paginator.new(klass, options)
      paginator.paginate
    end
    
    class Paginator
      
      attr_accessor :klass
      attr_accessor :options
      attr_accessor :total_rows
      attr_accessor :total_pages
      attr_accessor :results
      attr_accessor :current_page
      attr_accessor :results_per_page
      
      def initialize(klass, options = {})
        self.klass = klass
        self.options = options
        self.current_page = (self.options.delete(:current_page) || 1).to_i
        self.results_per_page = (self.options.delete(:results_per_page) || configatron.mack.database.pagination.results_per_page).to_i
      end
      
      def paginate
        raise NoMethodError.new('paginate')
      end
      
      def has_next?
        return self.current_page != self.total_pages && self.total_pages > 1
      end
      
      def has_prev?
        return self.current_page != 1 && self.total_pages > 1
      end
      
      def ==(other)
        self.results == other.results
      end
      
    end
    
  end
end