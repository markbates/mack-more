module Mack
  
  module Controller

    module ClassMethods
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