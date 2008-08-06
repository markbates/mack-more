module Mack
  module Routes # :nodoc:
    class RouteMap # :nodoc:
      
      # let's make sure we only do the alias_method once.
      unless self.private_instance_methods.include?("normal_connect_with_named_route")
        
        alias_method :normal_connect_with_named_route, :connect_with_named_route
      
        def connect_with_named_route(n_route, pattern, options = {}) # :nodoc:
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
        
      end
      
    end # RouteMap
  end # Routes
end # Mack