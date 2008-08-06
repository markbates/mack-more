module Mack
  module Distributed
    module Routes # :nodoc:
      # A class used to house the Mack::Routes::Url module for distributed applications.
      # Functionally this class does nothing, but since you can't cache a module, a class is needed.
      class Urls
        include DRbUndumped
        
        def initialize(dsd) # :nodoc:
          @dsd = dsd
        end
        
        def put
          Mack::Distributed::Utils::Rinda.register_or_renew(:space => app_config.mack.distributed_app_name.to_sym, 
                                                            :klass_def => :distributed_routes, 
                                                            :object => self, :timeout => 0)
        end
        
        def run(meth, options)
          self.send(meth, options)
        end
        
        class << self
          
          def get(app_name)
            Mack::Distributed::Utils::Rinda.read(:space => app_name.to_sym, :klass_def => :distributed_routes)
          end
          
        end
        
      end # Urls
      
    end # Routes
  end # Distributed
  
  module Routes # :nodoc:
    module Urls
      # Retrieves a distributed route from a DRb server.
      # 
      # Example:
      #   droute_url(:app_1, :home_page_url)
      #   droute_url(:registration_app, :signup_url, {:from => :google})
      def droute_url(app_name, route_name, options = {})
        if app_config.mack.share_routes
          d_urls = Mack::Distributed::Routes::Urls.get(app_name)
          # return d_urls.send(route_name, options)
          # ivar_cache("droute_url_hash") do
          #   {}
          # end
          # d_urls = @droute_url_hash[app_name.to_sym]
          # if d_urls.nil?
          #   d_urls = Mack::Distributed::Routes::UrlCache.get(app_name.to_sym)
          #   @droute_url_hash[app_name.to_sym] = d_urls
          #   if d_urls.nil?
          #     raise Mack::Distributed::Errors::UnknownApplication.new(app_name)
          #   end
          # end
          route_name = route_name.to_s
          if route_name.match(/_url$/)
            unless route_name.match(/_distributed_url$/)
              route_name.gsub!("_url", "_distributed_url")
            end
          else
            route_name << "_distributed_url"
          end
          raise Mack::Distributed::Errors::UnknownRouteName.new(app_name, route_name) unless d_urls.respond_to?(route_name)
          return d_urls.run(route_name, options)
          # if d_urls.run.respond_to?(route_name)
          #   return d_urls.run.send(route_name, options)
          # else
          #   raise Mack::Distributed::Errors::UnknownRouteName.new(app_name, route_name)
          # end
        else
          return nil
        end
      end # droute_url
    end # Urls
  end # Routes
  
end # Mack

Mack::Routes.after_class_method(:build) do
  if app_config.mack.share_routes
    raise Mack::Distributed::Errors::ApplicationNameUndefined.new if app_config.mack.distributed_app_name.nil?
    
    d_urls = Mack::Distributed::Routes::Urls.new(app_config.mack.distributed_site_domain)
    d_urls.put
    Mack::Routes::Urls.include_safely_into(Mack::Distributed::Routes::Urls)
  end
end