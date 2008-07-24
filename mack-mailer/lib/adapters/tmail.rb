require File.join(File.dirname(__FILE__), "base")
require 'base64'
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

          # set text and html bodies
          main_body = TMail::Mail.new
          unless mack_mailer.text_body.blank?
            text = TMail::Mail.new
            text.content_type = "text/plain"
            text.body = mack_mailer.text_body
            main_body.parts << text
          end
          unless mack_mailer.html_body.blank?
            html = TMail::Mail.new
            html.content_type = "text/html"
            html.body = mack_mailer.html_body
            main_body.parts << html
          end
          unless main_body.parts.empty?
            main_body.content_type = "multipart/alternative"
            @tmail.parts << main_body
          end

          # set attachments, if any.
          mack_mailer.attachments.each do |at|
            attachment = TMail::Mail.new
            attachment.body = Base64.encode64(at.body)
            attachment.transfer_encoding = "Base64"
            attachment.content_type = "application/octet-stream"
            attachment['Content-Disposition'] = "attachment; filename=#{at.file_name}"
            @tmail.parts << attachment
          end
          
          @tmail.content_type = mack_mailer.content_type
        end
        
      end # Tmail
    end # Adapters
  end # Mailer
end # Mack