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
    attr_accessor :date_sent
    attr_accessor :mime_version
    
    def build(options = {})
      options.each do |k,v|
        self.send("#{k}=", v)
      end
    end
    
    def text_body
      if @text_body.blank?
        @text_body = build_template(:text)
      end
      return @text_body
    end
    
    def html_body
      if @html_body.blank?
        @html_body = build_template(:html)
      end
      @html_body
    end
    
    def mime_version
      (@mime_version ||= "1.0")
    end
    
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
    
    def date_sent
      (@date_sent ||= Time.now)
    end
    
    def reply_to
      (@reply_to || self.from)
    end
    
    def attach(file)
      raise ArgumentError.new unless file.is_a?(Mack::Mailer::Attachment)
      attachments << file
    end
    
    def has_attachments?
      !attachments.empty?
    end
    
    def attachments
      @attachments ||= []
    end
    
    def deliver(handler = app_config.mailer.deliver_with)
      "Mack::Mailer::DeliveryHandlers::#{handler.camelcase}".constantize.deliver(self)
    end
    
    def destinations
      [self.to, self.cc, self.bcc].flatten.compact
    end
    
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