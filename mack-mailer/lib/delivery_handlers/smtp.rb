require 'net/smtp'
module Mack
  module Mailer
    module DeliveryHandlers
      module Smtp
        
        def self.deliver(mail)
          smtp_settings = app_config.mailer.smtp_settings
          Net::SMTP.start(smtp_settings[:address], smtp_settings[:port], 
                          smtp_settings[:domain], smtp_settings[:user_name], 
                          smtp_settings[:password], smtp_settings[:authentication]) do |smtp|
            smtp.sendmail(mail.encode, mail.reply_to, mail.destinations)
          end
        end
        
      end # Smtp
    end # DeliveryHandlers
  end # Mailer
end # Mack