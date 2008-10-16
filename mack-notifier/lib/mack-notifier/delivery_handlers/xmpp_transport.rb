module Mack
  module Notifier
    module DeliveryHandlers # :nodoc:
      # Delivers Mack::Notifier objects using XMPP (Jabber)
      module XmppTransport
        
        def self.deliver(xmpp_msg)
            xmpp_settings = configatron.mack.notifier.xmpp
            jid_str = xmpp_settings.jid
            jid_str += ("/" + xmpp_settings.jid_resource) if !jid_str.index("/")
            password = xmpp_settings.password
            client = Jabber::Simple.new(jid_str, password)
            thr = Thread.new {
              begin
                Timeout::timeout(20) do
                  buddies = {}
                  buddies[xmpp_msg.deliverable.to.to_s] = :offline
                  # try to get the presence update
                  sleep(1)
                  client.presence_updates do |update|
                    from = update[0].to_s
                    presence = update[1].to_s
                    if buddies.has_key?(from)
                      buddies[from] = presence
                    end
                    puts "#{from} --> #{presence}"
                  end
                  # now send the message
                  if buddies[xmpp_msg.deliverable.to].to_s == "online"
                    puts "#{xmpp_msg.deliverable.to} is online, delivering message"
                    client.deliver(xmpp_msg.deliverable.to, xmpp_msg.deliverable)
                  
                    # loop again to find the response
                    if xmpp_settings.wait_for_response
                      loop do
                        client.received_messages do |ret_msg|
                          if ret_msg.type == :error
                            err_element = ret_msg.elements.find { |x| x.name == "error" }
                            if err_element
                              @error = Mack::Errors::XmppSendError.new(err_element.attribute("code"), err_element.text)
                              err_str = @error.to_s
                            else
                              @error = Mack::Errors::XmppError.new("Unknown error")
                              err_str = @error.to_s
                            end
                          else
                            if ret_msg.body == "ack"
                              @msg_received = true
                            end
                          end
                        end # received_msg
                        break if @msg_received or @error
                      end # loop
                    end # if wait_for_response
                  else 
                    @error = Mack::Errors::XmppUserNotOnline.new(xmpp_msg.deliverable.to)
                    raise @error
                  end # if online
                end # timeout
              rescue Timeout::Error => ex
                @error = ex
              rescue Exception => ex
                puts ex
              end
            }
            thr.join
            raise @error if @error
        end
        
        # def self.deliver(xmpp_msg)
        #   # debugger
        #   xmpp_settings = configatron.mack.notifier.xmpp
        #   
        #   jid_str = xmpp_settings.jid
        #   jid_str += ("/" + xmpp_settings.jid_resource) if !jid_str.index("/")
        #   
        #   jid = JID::new(jid_str)
        #   mainthread = Thread.current
        #   client = Client::new(jid)
        #   client.connect
        # 
        #   if client.auth(xmpp_settings.password)
        #     client.send(Presence.new.set_show(:chat))               
        #     if xmpp_settings.wait_for_response
        #       thr = Thread.new {
        #         begin
        #           Timeout::timeout(xmpp_settings.response_wait_time) {
        #             client.add_message_callback do |ret_msg|
        #               debugger
        #               if ret_msg.type == :error
        #                 err_element = ret_msg.elements.find { |x| x.name == "error" }
        #                 if err_element
        #                   @error = Mack::Errors::XmppSendError.new(err_element.attribute("code"), err_element.text)
        #                   err_str = @error.to_s
        #                 else
        #                   @error = Mack::Errors::XmppError.new("Unknown error")
        #                   err_str = @error.to_s
        #                 end
        #                 mainthread.wakeup
        #               else
        #                 if ret_msg.body == xmpp_settings.response_message
        #                   mainthread.wakeup
        #                 end
        #               end
        #               true
        #             end
        #           }
        #         rescue Timeout::Error
        #           mainthread.wakeup
        #         end
        #       }
        #     end
        #     
        #     Thread.stop if xmpp_settings.wait_for_response
        #     client.close
        #     thr.join if thr
        #     raise @error if @error
        #   end
        # end # deliver
      end # XmppTransport
    end # DeliveryHandlers
  end # Notifier
end # Mack