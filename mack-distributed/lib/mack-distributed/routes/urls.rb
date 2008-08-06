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
        else
          return nil
        end
      end # droute_url
    end # Urls
    
    class RouteMap
      alias_method :normal_connect_with_named_route, :connect_with_named_route
      
      def connect_with_named_route(n_route, pattern, options = {})
        n_route = n_route.methodize
        normal_connect_with_named_route(n_route, pattern, options)
        if app_config.mack.share_routes
          Mack::Routes::Urls.class_eval %{
            def #{n_route}_distributed_url(options = {})
              (@dsd || app_config.mack.distributed_site_domain) + #{n_route}_url(options)
            end
          }
        end
      end # connect_with_named_route
      
    end # RouteMap
    
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