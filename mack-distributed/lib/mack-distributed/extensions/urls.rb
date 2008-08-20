module Mack # :nodoc:
  module Routes # :nodoc:
    module Urls
      
      alias_deprecated_method :droute_url, :distributed_url, '0.7.0', '>=0.8.0'
      # Retrieves a distributed route from a DRb server.
      # 
      # Example:
      #   distributed_url(:app_1, :home_page_url)
      #   distributed_url(:registration_app, :signup_url, {:from => :google})
      def distributed_url(app_name, route_name, options = {})
        route_name = route_name.to_s
        if route_name.match(/_url$/)
          unless route_name.match(/_distributed_url$/)
            route_name.gsub!("_url", "_distributed_url")
          end
        else
          route_name << "_distributed_url"
        end
        
        if !app_config.mack.distributed_app_name.nil? && app_name.to_sym == app_config.mack.distributed_app_name.to_sym
          # if it's local let's just use it and not go out to Rinda
          return self.send(route_name, options)
        end
        d_urls = Mack::Distributed::Routes::Urls.get(app_name)
        raise Mack::Distributed::Errors::UnknownRouteName.new(app_name, route_name) unless d_urls.respond_to?(route_name)
        return d_urls.run(route_name, options)
      end # distributed_url
      
    end # Urls
  end # Routes
end # Mack