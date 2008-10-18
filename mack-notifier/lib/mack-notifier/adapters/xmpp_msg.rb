module Mack
  module Notifier
    module Adapters # :nodoc:
      
      class XmppMsgContainer 
        attr_accessor :messages
        attr_accessor :recipients
        def initialize
          self.messages = []
          self.recipients = []
        end
        
        def find_message_by_recipient(rcpt)
          self.messages.find { |x| x.to.to_s == rcpt.to_s }
        end
        
      end
      
      # All mail adapters need to extend this class.
      class Xmpp < Mack::Notifier::Adapters::Base
        include Jabber
        
        # The transformed (ie, converted, object)
        def transformed
          raise Mack::Errors::UnconvertedNotifier.new if @xmpp_msg.nil?
          return @xmpp_container
        end
        
        # Convert the Mack::Notifier object to the adapted object.
        def convert
          settings = configatron.mack.notifier.xmpp_settings
          arr = [mack_notifier.to].flatten
          @xmpp_container = XmppMsgContainer.new
          @xmpp_container.recipients = arr
          
          arr.each do |rcpt|
            xmpp_msg = Message::new
            xmpp_msg.set_type(:normal)
            xmpp_msg.set_to(rcpt)
            xmpp_msg.set_from(mack_notifier.from)
            xmpp_msg.set_subject(mack_notifier.subject)
            xmpp_msg.set_type(settings.message_type)
            unless mack_notifier.body(:plain).blank?
              xmpp_msg.set_body(mack_notifier.body(:plain))
            end

            @xmpp_container.messages << xmpp_msg
          end
          
          return @xmpp_container
        end
        
        # The RAW encoded String ready for delivery via SMTP, Sendmail, etc...
        def deliverable
          return @xmpp_container
        end
        
      end # Base
    end # Adapters
  end # Notifier
end # Mack