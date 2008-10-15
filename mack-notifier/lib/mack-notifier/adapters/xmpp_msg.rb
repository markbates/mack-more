module Mack
  module Notifier
    module Adapters # :nodoc:
      # All mail adapters need to extend this class.
      class Xmpp < Mack::Notifier::Adapters::Base
        include Jabber
        
        # The transformed (ie, converted, object)
        def transformed
          raise Mack::Errors::UnconvertedNotifier.new if @xmpp_msg.nil?
          return @xmpp_msg
        end
        
        # Convert the Mack::Notifier object to the adapted object.
        def convert
          settings = configatron.mack.notifier.xmpp_settings
          @xmpp_msg = Message::new
          @xmpp_msg.set_to(mack_notifier.to)
          @xmpp_msg.set_from(mack_notifier.from)
          @xmpp_msg.set_subject(mack_notifier.subject)
          @xmpp_msg.set_type(settings.message_type)
          
          unless mack_notifier.body(:plain).blank?
            @xmpp_msg.set_body(mack_notifier.body(:plain))
          end
          
          return @xmpp_msg
        end
        
        # The RAW encoded String ready for delivery via SMTP, Sendmail, etc...
        def deliverable
          return @xmpp_msg
        end
        
      end # Base
    end # Adapters
  end # Notifier
end # Mack