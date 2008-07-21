module Mack
  
  module Controller # :nodoc:

    module ClassMethods
      
      # Used to define which pages you would or would not like cached.
      # 
      # Examples:
      #  cache_pages # => will cache all pages for a controller
      #  cache_pages :only => [:index, :show] # => will only cache the index and show pages for a controller
      #  cache_pages :except => [:delete] # => will cache all pages except for the delete page for a controller
      def cache_pages(options = {})
        before_filter :set_page_cache_header, options
      end
      
    end

    private
    def set_page_cache_header
      response["cache_this_page"] = "true"
    end

  end # Controller

end # Mack