module Mack
  module Errors # :nodoc:
    
    # Thrown when a page is uncacheable
    class UncacheableError < StandardError
      def initialize(message) # :nodoc:
        super(message)
      end
    end # UncacheableError
    
  end # Errors
end # Mack