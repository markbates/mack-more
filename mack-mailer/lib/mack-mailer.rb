require 'tmail'
require File.join(File.dirname(__FILE__), "paths")
require File.join(File.dirname(__FILE__), "loader")
require File.join(File.dirname(__FILE__), "errors")
[:delivery_handlers, :adapters].each do |dir|
  Dir.glob(File.join(File.dirname(__FILE__), dir.to_s, "**/*.rb")).each do |h|
    require h
  end
end

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
    attr_accessor :content_type
    
    def mime_version
      (@mime_version ||= "1.0")
    end
    
    def content_type
      (@content_type ||= "text/plain")
    end
    
    def date_sent
      (@date_sent ||= Time.now)
    end
    
    def reply_to
      (@reply_to || self.from)
    end
    
    def attach(file)
      raise NoMethodError.new(:attach)
    end
    
    def has_attachments?
      raise NoMethodError.new(:has_attachments?)
    end
    
    def attachments
      raise NoMethodError.new(:attachments)
    end
    
    def deliver(handler = app_config.mailer.deliver_with)
      "Mack::Mailer::DeliveryHandlers::#{handler.camelcase}".constantize.deliver(self)
    end
    
    def destinations
      [self.to, self.cc, self.bcc].flatten
    end
    
    def deliverable
      
    end
    
  end
end