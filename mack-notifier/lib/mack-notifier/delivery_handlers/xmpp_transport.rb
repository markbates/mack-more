require 'xmpp4r/client'

module Mack
  module Notifier
    module DeliveryHandlers # :nodoc:
      # Delivers Mack::Notifier objects using XMPP (Jabber)
      module XmppTransport
        include Jabber
        
        # def self.deliver(xmpp_msg)
        #   xmpp_settings = configatron.mack.notifier.xmpp_settings
        #   debugger
        #   jid_str = xmpp_settings.jid
        #   jid_str += ("/" + xmpp_settings.jid_resource) if !jid_str.index("/")
        #   client = Jabber::Simple.new(jid_str, xmpp_settings.password)
        #   msg = xmpp_msg.deliverable
        #   client.deliver(msg.to.to_s, msg, :chat)
        #   client.received_messages { |x| puts x.inspect }
        # end
        
        def self.deliver(xmpp_msg)
          # debugger
          xmpp_settings = configatron.mack.notifier.xmpp_settings
          
          jid_str = xmpp_settings.jid
          jid_str += ("/" + xmpp_settings.jid_resource) if !jid_str.index("/")
          
          jid = JID::new(jid_str)
          
          client = Client::new(jid)
          client.connect
          if client.auth(xmpp_settings.password)
            mainthread = Thread.current            
            client.send(xmpp_msg.deliverable)
            
            client.add_message_callback do |ret_msg|
              if ret_msg.type == :error
                err_element = ret_msg.elements.find { |x| x.name == "error" }
                if err_element
                  @error = Mack::Errors::XmppSendError.new(err_element.attribute("code"), err_element.text)
                  err_str = @error.to_s
                else
                  @error = Mack::Errors::XmppError.new("Unknown error")
                  err_str = @error.to_s
                end
              end
              mainthread.wakeup
            end
            Thread.stop
            client.close
            
            raise @error if @error
          else
            raise Mack::Errors::XmppError.new(jid_str)
          end
        end
      end # XmppTransport
    end # DeliveryHandlers
  end # Notifier
end # Mack