module Mack
  module Notifier
    module Adapters # :nodoc:
      # All mail adapters need to extend this class.
      class Base
        
        # The origina Mack::Notifier object passed in.
        attr_accessor :mack_notifier
        
        def initialize(mail) # :nodoc:
          self.mack_notifier = mail
        end
        
        # The transformed (ie, converted, object)
        needs_method :transformed
        # Convert the Mack::Notifier object to the adapted object.
        needs_method :convert
        # The RAW encoded String ready for delivery via SMTP, Sendmail, etc...
        needs_method :deliverable
        
      end # Base
    end # Adapters
  end # Notifier
end # Mack