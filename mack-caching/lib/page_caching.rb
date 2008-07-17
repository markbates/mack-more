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
            response.write(page.body)
            return response.finish
          end
          ret = @app.call(env)
          res = ret[2]
          Cachetastic::Caches::PageCache.set(request.fullpath, Mack::Caching::PageCaching::Page.new(res.body))
          return ret
        end
        return @app.call(env)
      end

      class Page
        
        attr_reader :body
        attr_reader :content_type
        attr_reader :status
        
        def initialize(body, content_type = "text/html", status = 200)
          if body.is_a?(Array)
            raise Mack::Caching::PageCaching::UncacheableError.new("Multipart pages can not be cached!") if body.size > 1
            @body = body.first
          else
            @body = body
          end
          @content_type = content_type
          @status = status
        end
        
        def to_s
          @body
        end
        
      end
      
    end # PageCaching
  end # Caching
end # Mack

Mack::Utils::Server::Registry.instance.add(Mack::Caching::PageCaching)