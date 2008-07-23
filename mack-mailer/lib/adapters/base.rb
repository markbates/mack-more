module Mack
  module Mailer
    module Adapters # :nodoc:
      class Base
        
        attr_accessor :mack_mailer
        
        def initialize(mail)
          self.mack_mailer = mail
        end
        
        needs_method :transformed
        needs_method :convert
        needs_method :deliverable
        
      end # Base
    end # Adapters
  end # Mailer
end # Mack