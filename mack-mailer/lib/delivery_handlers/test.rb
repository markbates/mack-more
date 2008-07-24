module Mack
  module Mailer
    module DeliveryHandlers # :nodoc:
      # Delivers Mack::Mailer objects to an Array.
      module Test
        
        def self.deliver(mail)
          EmailRegistry.add(mail)
        end
        
        class EmailRegistry < Mack::Utils::Registry
        end
        
      end # Test
    end # DeliveryHandlers
  end # Mailer
end # Mack