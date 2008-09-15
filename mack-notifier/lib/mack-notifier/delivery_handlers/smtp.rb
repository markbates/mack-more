require 'net/smtp'
module Mack
  module Notifier
    module DeliveryHandlers # :nodoc:
      # Delivers Mack::Notifier objects using Net::SMTP.
      module Smtp
        
        def self.deliver(mail)
          smtp_settings = configatron.mack.notifier.smtp_settings
          Net::SMTP.start(smtp_settings.address, smtp_settings.port, 
                          smtp_settings.domain, smtp_settings.user_name, 
                          smtp_settings.password, smtp_settings.authentication) do |smtp|
            smtp.sendmail(mail.deliverable, mail.reply_to, mail.recipients)
          end
        end
        
      end # Smtp
    end # DeliveryHandlers
  end # Notifier
end # Mack