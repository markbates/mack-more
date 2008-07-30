module Mack
  module Notifier
    module DeliveryHandlers # :nodoc:
      # Delivers Mack::Notifier objects using sendmail.
      module SendMail
        
        def self.deliver(mail)
          sendmail_settings = app_config.notifier.sendmail_settings
          sendmail_settings.symbolize_keys!
          sendmail_args = sendmail_settings[:arguments]
          sendmail_args += " -f \"#{mail.reply_to}\"" if mail.reply_to
          IO.popen("#{sendmail_settings[:location]} #{sendmail_args}","w+") do |sm|
            sm.print(mail.deliverable.gsub(/\r/, ''))
            sm.flush
          end
        end
        
      end # SendMail
    end # DeliveryHandlers
  end # Notifier
end # Mack