module Mack # :nodoc:
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
  end # Routes
end # Mack