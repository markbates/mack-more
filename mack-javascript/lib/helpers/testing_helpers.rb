module Mack
  module Testing
    module Helpers
      #simulates an ajax request
      def xhr(method, uri, options = {})
        options = {:input => options.to_params} if method == :post || method == :put
        build_response(request.send(method, uri, build_request_options(options.merge({"HTTP_X_REQUESTED_WITH" => 'XMLHttpRequest', "HTTP_ACCEPT" => 'text/javascript, text/html, application/xml, text/xml, */*'}))))
      end
    end
  end
end

