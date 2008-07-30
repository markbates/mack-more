module Mack
  module Notifier
    module DeliveryHandlers # :nodoc:
      # Delivers Mack::Notifier objects to an Array.
      module Test
        
        def self.deliver(mail)
          EmailRegistry.add(mail)
        end
        
        class EmailRegistry < Mack::Utils::RegistryList # :nodoc:
        end
        
      end # Test
    end # DeliveryHandlers
  end # Notifier
end # Mack