module Mack
  module Distributed # :nodoc:
    module Object
      
      def self.included(base)
        base.class_eval do
          include ::DRbUndumped
        end
      end
      
    end # Object
  end # Distributed
end # Mack