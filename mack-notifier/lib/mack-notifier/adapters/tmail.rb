require File.join(File.dirname(__FILE__), "base")
require 'base64'
module Mack
  module Notifier
    module Adapters # :nodoc:
      # Converts a Mack::Notifier object into a TMail object.
      class Tmail < Mack::Notifier::Adapters::Base
        
        # Returns the underlying TMail object.
        # Raises Mack::Errors::UnconvertedNotifier if the convert method hasn't
        # been called first.
        def transformed
          raise Mack::Errors::UnconvertedNotifier.new if @tmail.nil?
          @tmail
        end
        
        # Returns the ready to be delivered encoded String
        def deliverable
          transformed.encoded
        end
        
        # Converts the Mack::Notifier object to a TMail object.
        def convert
          @tmail = TMail::Mail.new 
          @tmail.to =           mack_notifier.to
          @tmail.cc =           mack_notifier.cc
          @tmail.bcc =          mack_notifier.bcc
          @tmail.reply_to =     mack_notifier.reply_to
          @tmail.from =         mack_notifier.from
          @tmail.subject =      mack_notifier.subject
          @tmail.date =         mack_notifier.date_sent
          @tmail.mime_version = mack_notifier.mime_version

          # set text and html bodies
          main_body = TMail::Mail.new
          unless mack_notifier.body(:plain).blank?
            text = TMail::Mail.new
            text.content_type = "text/plain"
            text.body = mack_notifier.body(:plain)
            main_body.parts << text
          end
          unless mack_notifier.body(:html).blank?
            html = TMail::Mail.new
            html.content_type = "text/html"
            html.body = mack_notifier.body(:html)
            main_body.parts << html
          end

          unless main_body.parts.empty?
            main_body.content_type = "multipart/alternative"
            if mack_notifier.attachments.any? # there's an attachment
              @tmail.parts << main_body
            else
              if main_body.parts.size == 1
                @tmail.body = main_body.parts.first.body
              else
                @tmail.parts << main_body
              end
            end
          end

          # set attachments, if any.
          mack_notifier.attachments.each do |at|
            attachment = TMail::Mail.new
            attachment.body = Base64.encode64(at.body)
            attachment.transfer_encoding = "Base64"
            attachment.content_type = "application/octet-stream"
            attachment['Content-Disposition'] = "attachment; filename=#{at.file_name}"
            @tmail.parts << attachment
          end
          
          @tmail.content_type = mack_notifier.content_type
        end
        
      end # Tmail
    end # Adapters
  end # Notifier
end # Mack