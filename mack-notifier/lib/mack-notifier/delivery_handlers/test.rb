module Mack
  module Notifier
    module DeliveryHandlers # :nodoc:
      # Delivers Mack::Notifier objects to an Array.
      module Test
        
        def self.deliver(notifier)
          NotifierRegistry.add(notifier)
        end
        
        class NotifierRegistry < Mack::Utils::RegistryList # :nodoc:
        end
        
      end # Test
    end # DeliveryHandlers
  end # Notifier
end # Mack