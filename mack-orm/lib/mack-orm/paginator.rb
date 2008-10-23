module Mack
  module Database
    
    # Creates a new Mack::Database::Paginator class and calls the paginate method on it.
    def self.paginate(klass, options = {}, query_options = {})
      paginator = Mack::Database::Paginator.new(klass, options, query_options)
      paginator.paginate
    end
    
    # This class provides a clean API for doing database pagination.
    # The paginate methods needs to be implemented by the ORM developer.
    class Paginator
      
      # The Class that all queries will be called on
      attr_accessor :klass
      # Options for the Paginator itself
      attr_accessor :options
      # Options for the queries to be run
      attr_accessor :query_options
      # The total rows returned by the Paginator
      attr_accessor :total_results
      # The total pages available
      attr_accessor :total_pages
      # The actual records themselves
      attr_accessor :results
      # The current page in the pagination. Default is 1.
      attr_accessor :current_page
      # The number of results to be returned per page.
      attr_accessor :results_per_page
      
      # Takes the Class that all queries will be run on, options for the Paginator,
      # and options for the queries that are going to be run.
      def initialize(klass, options = {}, query_options = {})
        self.klass = klass
        self.options = options
        self.query_options = query_options
        self.current_page = (self.options.delete(:current_page) || 1).to_i
        self.results_per_page = (self.options.delete(:results_per_page) || configatron.mack.database.pagination.results_per_page).to_i
      end
      
      # Implement this method in your ORM package. It should return <tt>self</tt> and set the following
      # accessors: <tt>total_results</tt>, <tt>total_pages</tt>, <tt>results</tt>.
      def paginate
        raise NoMethodError.new('paginate')
      end
      
      # Is there a next page?
      def has_next?
        return self.current_page != self.total_pages && self.total_pages > 1
      end
      
      # Is there a previous page?
      def has_previous?
        return self.current_page != 1 && self.total_pages > 1
      end
      
      # The starting index for this group of results.
      # Useful for building things like:
      #   Displaying 11 - 20 of 56 results.
      def start_index
        return 0 if self.total_results == 0
        si = ((self.current_page - 1) * self.results_per_page)
        return (si >= 0 ? si + 1 : 0)
      end
      
      # The ending index for this group of results.
      # Useful for building things like:
      #   Displaying 11 - 20 of 56 results.
      def end_index
        ei = self.current_page * self.results_per_page
        return (ei < self.total_results ? ei : self.total_results)
      end
      
      def ==(other) # :nodoc:
        self.results == other.results
      end
      
    end
    
  end
end