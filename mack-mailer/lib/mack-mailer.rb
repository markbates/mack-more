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