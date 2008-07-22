require File.join(File.dirname(__FILE__), "paths")
require File.join(File.dirname(__FILE__), "loader")
Dir.glob(File.join(File.dirname(__FILE__), "delivery_handlers", "**/*.rb")).each do |h|
  require h
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
    
    def encode
      
    end
    
  end
end