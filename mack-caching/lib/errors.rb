module Mack
  module Errors
    
    # Thrown when a page is uncacheable
    class UncacheableError < StandardError
      def initialize(message)
        super(message)
      end
    end # UncacheableError
    
  end # Errors
end # Mack