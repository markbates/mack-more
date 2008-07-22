require File.join(File.dirname(__FILE__), "base")
module Mack
  module Mailer
    module Adapters # :nodoc:
      class Tmail < Mack::Mailer::Adapters::Base
        
        def to_s
          
        end
        
        def transformed
          raise Mack::Errors::UnconvertedMailer.new if @tmail.nil?
          @tmail
        end
        
        def convert
          @tmail = TMail::Mail.new 
          @tmail.to =           mack_mailer.to
          @tmail.cc =           mack_mailer.cc
          @tmail.bcc =          mack_mailer.bcc
          @tmail.reply_to =     mack_mailer.reply_to
          @tmail.subject =      mack_mailer.subject
          @tmail.date =         mack_mailer.date_sent
          @tmail.mime_version = mack_mailer.mime_version
          @tmail.content_type = mack_mailer.content_type
          @tmail.parts <<       mack_mailer.text_body unless mack_mailer.text_body.blank?
          @tmail.parts <<       mack_mailer.html_body unless mack_mailer.html_body.blank?
          # @tmail.body = mack_mailer.
        end
        
      end # Tmail
    end # Adapters
  end # Mailer
end # Mack