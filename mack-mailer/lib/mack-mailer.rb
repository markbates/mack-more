require File.join(File.dirname(__FILE__), "paths")
require File.join(File.dirname(__FILE__), "loader")

module Mack # :nodoc:
  module Mailer
    
    attr_accessor :to
    attr_accessor :cc
    attr_accessor :bcc
    attr_accessor :from
    attr_accessor :reply_to
    attr_accessor :subject
    attr_accessor :text_body
    attr_accessor :html_body
    
    def attach(file)
      raise NoMethodError.new(:attach)
    end
    
    def has_attachments?
      raise NoMethodError.new(:has_attachments?)
    end
    
    def attachments
      raise NoMethodError.new(:attachments)
    end
    
    def deliver
      raise NoMethodError.new(:deliver)
    end
    
  end
end

=begin
def smtp_settings
  {
    :address        => "localhost",
    :port           => 25,
    :domain         => 'localhost.localdomain',
    :user_name      => nil,
    :password       => nil,
    :authentication => nil
  }
end

def sendmail_settings
  {
    :location       => '/usr/sbin/sendmail',
    :arguments      => '-i -t'
  }
end

def perform_delivery_smtp(mail)
  destinations = mail.destinations
  mail.ready_to_send
  sender = mail.reply_to

  Net::SMTP.start(smtp_settings[:address], smtp_settings[:port], smtp_settings[:domain],
      smtp_settings[:user_name], smtp_settings[:password], smtp_settings[:authentication]) do |smtp|
    smtp.sendmail(mail.encoded, sender, destinations)
  end
end

def perform_delivery_sendmail(mail)
  sendmail_args = sendmail_settings[:arguments]
  sendmail_args += " -f \"#{mail.reply_to}\"" if mail.reply_to
  IO.popen("#{sendmail_settings[:location]} #{sendmail_args}","w+") do |sm|
    sm.print(mail.encoded.gsub(/\r/, ''))
    sm.flush
  end
end

=end