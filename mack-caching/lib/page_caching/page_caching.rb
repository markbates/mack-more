require File.join(File.dirname(__FILE__), "controller_extensions")
require File.join(File.dirname(__FILE__), "..", "errors")
module Mack # :nodoc:
  module Caching # :nodoc:
    class PageCaching # :nodoc:
      
      def initialize(app) # :nodoc:
        @app = app
      end
      
      def call(env) # :nodoc:
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
          unless ret[2].is_a?(Rack::File)
            res = ret[2]
            if res["cache_this_page"] && res.successful?
              Cachetastic::Caches::PageCache.set(request.fullpath, Mack::Caching::PageCaching::Page.new(res.body, res["Content-Type"]))
            end
          end
          return ret
        end
        return @app.call(env)
      end

      class Page # :nodoc:
        
        attr_reader :body
        attr_reader :content_type
        
        def initialize(body, content_type = "text/html")
          if body.is_a?(Array)
            raise Mack::Errors::UncacheableError.new("Multipart pages can not be cached!") if body.size > 1
            @body = body.first
          else
            @body = body
          end
          @content_type = content_type
        end
        
        def to_s
          @body
        end
        
      end # Page
      
    end # PageCaching
    
  end # Caching
end # Mack

Mack::Utils::RunnersRegistry.add(Mack::Caching::PageCaching, 0)