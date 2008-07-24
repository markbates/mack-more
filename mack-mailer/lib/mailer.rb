module Mack # :nodoc:
  # The heart and soul of the mack-mailer package.
  module Mailer
    
    attr_accessor :to
    attr_accessor :cc
    attr_accessor :bcc
    attr_accessor :from
    attr_accessor :reply_to
    attr_accessor :subject
    attr_accessor :text_body
    attr_accessor :html_body
    attr_accessor :date_sent
    attr_accessor :mime_version
    attr_accessor :content_type
    
    # A helper method that takes a Hash and will populate the email with the key/value pairs of that Hash.
    def build(options = {})
      options.each do |k,v|
        self.send("#{k}=", v)
      end
    end
    
    # Returns the text_body of the email. If there is no text_body set it will attempt to build one using
    # the text.erb template for this mailer.
    def text_body
      if @text_body.blank?
        @text_body = build_template(:text)
      end
      return @text_body
    end
    
    # Returns the html_body of the email. If there is no html_body set it will attempt to build one using
    # the html.erb template for this mailer.
    def html_body
      if @html_body.blank?
        @html_body = build_template(:html)
      end
      @html_body
    end
    
    # Returns the mime_version of the email, defaults to "1.0"
    def mime_version
      (@mime_version ||= "1.0")
    end
    
    # This will attempt to determine the content type of the email, unless one is already specified. 
    def content_type
      return @content_type unless @content_type.blank?
      if has_attachments?
        return "multipart/mixed"
      elsif !text_body.blank? && !html_body.blank?
        return "multipart/alternative"
      elsif html_body
        return "text/html"
      else
        return "text/plain"
      end
    end
    
    # Returns the date sent, defaults to Time.now
    def date_sent
      (@date_sent ||= Time.now)
    end
    
    # Returns the reply to address, defaults to the from address.
    def reply_to
      (@reply_to || self.from)
    end
    
    # Adds a Mack::Mailer::Attachment to the email.
    # Raise ArgumentError if the parameter is not a Mack::Mailer::Attachment
    def attach(file)
      raise ArgumentError.new unless file.is_a?(Mack::Mailer::Attachment)
      attachments << file
    end
    
    # Returns true if there are attachments.
    def has_attachments?
      !attachments.empty?
    end
    
    # Returns the attachments Array.
    def attachments
      @attachments ||= []
    end
    
    # Delivers the email with the configured Mack::Mailer::DeliveryHandlers class.
    def deliver(handler = app_config.mailer.deliver_with)
      "Mack::Mailer::DeliveryHandlers::#{handler.camelcase}".constantize.deliver(self)
    end
    
    # Returns all the recipients of this email.
    def recipients
      [self.to, self.cc, self.bcc].flatten.compact
    end
    
    # Returns a ready to be delivered, encoded, version of the email.
    def deliverable(adapter = app_config.mailer.adapter)
      adap = "Mack::Mailer::Adapters::#{adapter.camelcase}".constantize.new(self)
      adap.convert
      adap.deliverable
    end
    
    private
    def build_template(format)
      begin
        vt = Mack::Rendering::ViewTemplate.new(:mailer, self.class.to_s.underscore, {:locals => {:mailer => self}, :format => format.to_s})
        return vt.compile_and_render
      rescue Mack::Errors::ResourceNotFound => e
      end
      return nil
    end
    
  end # Mailer
end # Mack