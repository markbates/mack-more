module Mack
  module Mailer
    module DeliveryHandlers # :nodoc:
      # Delivers Mack::Mailer objects using sendmail.
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
        
      end # SendMail
    end # DeliveryHandlers
  end # Mailer
end # Mack