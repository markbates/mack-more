module Mack
  module Notifier
    module DeliveryHandlers # :nodoc:
      # Delivers Mack::Notifier objects using XMPP (Jabber)
      module XmppTransport
        include Jabber
        
        def self.deliver(xmpp_msg)
          # debugger
          xmpp_settings = configatron.mack.notifier.xmpp_settings
          
          jid_str = xmpp_settings.jid
          jid_str += ("/" + xmpp_settings.jid_resource) if !jid_str.index("/")
          
          jid = JID::new(jid_str)
          mainthread = Thread.current
          client = Client::new(jid)
          client.connect

          if client.auth(xmpp_settings.password)
            client.send(Presence.new.set_show(:chat))            
            client.send(xmpp_msg.deliverable)
            
            if xmpp_settings.wait_for_response
              thr = Thread.new {
                begin
                  Timeout::timeout(xmpp_settings.response_wait_time) {
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
                        mainthread.wakeup
                      else
                        if ret_msg.body == xmpp_settings.response_message
                          mainthread.wakeup
                        end
                      end
                      true
                    end
                  }
                rescue Timeout::Error
                  mainthread.wakeup
                end
              }
            end
            
            Thread.stop if xmpp_settings.wait_for_response
            client.close
            thr.join if thr
            raise @error if @error
          end
        end
      end # XmppTransport
    end # DeliveryHandlers
  end # Notifier
end # Mack