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
        
        def deliverable
          transformed.encoded
        end
        
        def convert
          @tmail = TMail::Mail.new 
          @tmail.to =           mack_mailer.to
          @tmail.cc =           mack_mailer.cc
          @tmail.bcc =          mack_mailer.bcc
          @tmail.reply_to =     mack_mailer.reply_to
          @tmail.from =         mack_mailer.from
          @tmail.subject =      mack_mailer.subject
          @tmail.date =         mack_mailer.date_sent
          @tmail.mime_version = mack_mailer.mime_version
          mack_mailer.attachments.each do |at|
            # attachment = TMail::Attachment.new(at.body)
            # attachment.content_type = at.content_type
            # attachment.original_filename = "foo.png"
            mail = TMail::Mail.new
            mail.content_type = at.content_type
            mail.set_disposition("attachment", {"filename" => "foo.png"})
            mail.body = at.body
            @tmail.parts << mail
          end
          unless mack_mailer.text_body.blank?
            text = TMail::Mail.new
            text.content_type = "text/plain"
            text.body = mack_mailer.text_body
            @tmail.parts << text
          end
          unless mack_mailer.html_body.blank?
            html = TMail::Mail.new
            html.content_type = "text/html"
            html.body = mack_mailer.html_body
            @tmail.parts << html
          end
          # @tmail.content_type = mack_mailer.content_type
        end
        
      end # Tmail
    end # Adapters
  end # Mailer
end # Mack