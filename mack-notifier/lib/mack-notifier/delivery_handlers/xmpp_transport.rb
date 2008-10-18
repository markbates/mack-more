module Mack
  module Notifier
    module DeliveryHandlers # :nodoc:
      # Delivers Mack::Notifier objects using XMPP (Jabber)
      module XmppTransport
        
        def self.check_availability(client, recipients)
          buddies = {}
          recipients.each do |rcpt|
            buddies[rcpt] = :offline
          end

          # try to get the presence update
          sleep(1)
          client.presence_updates do |update|
            from = update[0].to_s
            presence = update[1].to_s
            if buddies.has_key?(from)
              buddies[from] = presence
            end
            Mack.logger.info "#{from} --> #{presence}"
          end
          return buddies
        end
        
        def self.deliver_message(client, xmpp_msg, wait_for_response, xmpp_errors)
          Mack.logger.info "#{xmpp_msg.to} is online, delivering message"
          client.deliver(xmpp_msg.to, xmpp_msg)
          loop do
            client.received_messages { |ret_msg| @msg_received = true if ret_msg.body == "ack" }
            break if @msg_received or @error
          end if wait_for_response
          return xmpp_errors
        end
        
        def self.deliver(xmpp_msg)
          @ex ||= Mack::Errors::XmppError.new("xmpp error")
          xmpp_settings = configatron.mack.notifier.xmpp
          jid_str = xmpp_settings.jid
          jid_str += ("/" + xmpp_settings.jid_resource) if !jid_str.index("/")
          password = xmpp_settings.password
          client = Jabber::Simple.new(jid_str, password)
          thr = Thread.new {
            begin
              xmpp_msg = xmpp_msg.deliverable
              Timeout::timeout(20) do
                buddies = check_availability(client, xmpp_msg.recipients)

                online_buddies = buddies.keys.reject { |x| buddies[x].to_sym == :offline }
                offline_buddies = buddies.keys.reject { |x| buddies[x].to_sym == :online }

                if !offline_buddies.empty?
                  # there are offline buddies, log the errors
                  offline_buddies.each do |buddy|
                    err = Mack::Errors::XmppUserNotOnline.new(buddy)
                    @ex.add_error(:offline, err)
                  end
                end
                
                online_buddies.each do |buddy|
                  deliver_message(client, xmpp_msg.find_message_by_recipient(buddy), xmpp_settings.wait_for_response, @ex)
                end
                
                raise @ex if !@ex.empty?
              end # timeout
            rescue Timeout::Error => ex
              @error = ex
            rescue Exception => ex
            end
          }
          
          thr.join
          raise @ex if !@ex.empty?
        end
      end # XmppTransport
    end # DeliveryHandlers
  end # Notifier
end # Mack