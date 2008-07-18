module Mack
  module Caching
    class PageCaching
      
      def initialize(app)
        @app = app
      end

      def call(env)
        if app_config.use_page_caching
          request = Mack::Request.new(env)
          page = Cachetastic::Caches::PageCache.get(request.fullpath)
          if page
            response = Mack::Response.new
            response["Content-Type"] = page.content_type
            response.write(page.body)
            return response.finish
          end
          ret = @app.call(env)
          res = ret[2]
          if res["cache_this_page"] && res.successful?
            Cachetastic::Caches::PageCache.set(request.fullpath, Mack::Caching::PageCaching::Page.new(res.body, res["Content-Type"]))
          end
          return ret
        end
        return @app.call(env)
      end

      class Page
        
        attr_reader :body
        attr_reader :content_type
        
        def initialize(body, content_type = "text/html")
          if body.is_a?(Array)
            raise Mack::Caching::PageCaching::UncacheableError.new("Multipart pages can not be cached!") if body.size > 1
            @body = body.first
          else
            @body = body
          end
          @content_type = content_type
        end
        
        def to_s
          @body
        end
        
      end
      
    end # PageCaching
  end # Caching
  
  module Controller
    
    class << self
      def cache_pages(options = {})
        before_fitler :set_page_cache_header, options
      end
    end
    
    private
    def set_page_cache_header
      response["cache_this_page"] = "true"
    end
    
  end
  
end # Mack

Mack::Utils::Server::Registry.instance.add(Mack::Caching::PageCaching)