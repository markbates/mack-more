module Mack
  module Mailer
    module Adapters # :nodoc:
      # All mail adapters need to extend this class.
      class Base
        
        # The origina Mack::Mailer object passed in.
        attr_accessor :mack_mailer
        
        def initialize(mail) # :nodoc:
          self.mack_mailer = mail
        end
        
        # The transformed (ie, converted, object)
        needs_method :transformed
        # Convert the Mack::Mailer object to the adapted object.
        needs_method :convert
        # The RAW encoded String ready for delivery via SMTP, Sendmail, etc...
        needs_method :deliverable
        
      end # Base
    end # Adapters
  end # Mailer
end # Mack