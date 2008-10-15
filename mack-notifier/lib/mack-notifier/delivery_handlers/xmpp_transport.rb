require 'xmpp4r/client'

module Mack
  module Notifier
    module DeliveryHandlers # :nodoc:
      # Delivers Mack::Notifier objects using XMPP (Jabber)
      module XmppTransport
        include Jabber
        
        def self.deliver(xmpp_msg)
          debugger
          xmpp_settings = configatron.mack.notifier.xmpp_settings
          
          jid_str = xmpp_settings.jid
          jid_str += ("/" + xmpp_settings.jid_resource) if !jid_str.index("/")
          
          jid = JID::new(jid_str)
          
          client = Client::new(jid)
          client.connect
          if client.auth(xmpp_settings.password)
            client.send(xmpp_msg.deliverable)
          else
            Mack.logger.warn "Message (#{xmpp_msg.deliverable.subject}) cannot be sent, because jabber user:(#{jid_str}) cannot be authenticated."
          end
        end
      end # XmppTransport
    end # DeliveryHandlers
  end # Notifier
end # Mack