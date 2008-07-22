module Mack
  module Mailer
    module DeliveryHandlers
      module SendMail
        
        def self.deliver(mail)
          sendmail_settings = app_config.mailer.sendmail_settings
          sendmail_args = sendmail_settings[:arguments]
          sendmail_args += " -f \"#{mail.reply_to}\"" if mail.reply_to
          IO.popen("#{sendmail_settings[:location]} #{sendmail_args}","w+") do |sm|
            sm.print(mail.encode.gsub(/\r/, ''))
            sm.flush
          end
        end
        
      end # Smtp
    end # DeliveryHandlers
  end # Mailer
end # Mack