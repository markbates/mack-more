module Mack # :nodoc:
  # The heart and soul of the mack-notifier package.
  module Notifier
    
    attr_accessor :to
    attr_accessor :cc
    attr_accessor :bcc
    attr_accessor :from
    attr_accessor :reply_to
    attr_accessor :subject
    attr_accessor :date_sent
    attr_accessor :mime_version
    attr_accessor :content_type
    
    # A helper method that takes a Hash and will populate the notification with the key/value pairs of that Hash.
    # Use body_* to set a body part.
    def build(options = {})
      options.each do |k,v|
        k = k.to_s
        unless k.match(/^body_/)
          self.send("#{k}=", v)
        else
          k.gsub!("body_", "")
          self.body(k, v)
        end
      end
    end
    
    # If called with two parameters it will set the value of the body type to the second parameter.
    # 
    # Example:
    #   body(:plain, "hello") # => sets the 'plain' body to "hello"
    # 
    # If called with just one parameter it will return the value of that body type. If the value is nil
    # the template for that body type will be rendered.
    #
    # Example:
    #   body(:plain) # => "hello"
    #   body(:html) # => will call the html.erb template for this notifier.
    def body(part, value = nil)
      part = part.to_sym
      if value.nil?
        body = bodies[part]
        if body.blank?
          bodies[part] = build_template(part)
          return bodies[part]
        else
          return body
        end
      else
        bodies[part] = value
      end
    end
    
    # Returns the mime_version of the notification, defaults to "1.0"
    def mime_version
      (@mime_version ||= "1.0")
    end
    
    # This will attempt to determine the content type of the notification, unless one is already specified. 
    def content_type
      return @content_type unless @content_type.blank?
      if has_attachments?
        return "multipart/mixed"
      elsif !body(:plain).blank? && !body(:html).blank?
        return "multipart/alternative"
      elsif body(:html)
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
    
    # Adds a Mack::Notifier::Attachment to the notifier.
    # Raise ArgumentError if the parameter is not a Mack::Notifier::Attachment
    def attach(file)
      raise ArgumentError.new unless file.is_a?(Mack::Notifier::Attachment)
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
    
    # Delivers the notification with the configured Mack::Notifier::DeliveryHandlers class.
    # Returns false if there are any errors.
    def deliver(handler = deliver_with)
      begin
        deliver!(handler)
      rescue Exception => e
        return false
      end
      return true
    end
    
    # Delivers the email with the configured Mack::Notifier::DeliveryHandlers class.
    def deliver!(handler = deliver_with)
      "Mack::Notifier::DeliveryHandlers::#{handler.to_s.camelcase}".constantize.deliver(self)
    end
    
    # Returns all the recipients of this notifier.
    def recipients
      [self.to, self.cc, self.bcc].flatten.compact
    end
    
    # Returns a ready to be delivered, encoded, version of the notification.
    def deliverable(adap = adapter)
      adap = "Mack::Notifier::Adapters::#{adap.to_s.camelcase}".constantize.new(self)
      adap.convert
      adap.deliverable
    end
    
    # This method returns the adapter that will transform the Mack::Notifier object
    # and prepare it for delivery. This method returns the configatron.notifier.adapter
    # parameter. Override this in your Mack::Notifier class to specify a different adapter
    # or change the configatron parameter to globally affect all your Notifiers.
    # 
    # Default: :tmail
    def adapter
      configatron.mack.notifier.adapter
    end
    
    # This method returns the delivery handler that will delivers the Mack::Notifier object.
    # This method returns the configatron.mack.notifier.deliver_with parameter. Override this in 
    # your Mack::Notifier class to specify a different handler or change the configatron 
    # parameter to globally affect all your Notifiers.
    # 
    # Default: :sendmail
    def deliver_with
      configatron.mack.notifier.deliver_with
    end
    
    private
    def bodies
      @bodies ||= {}
    end
    
    def build_template(format)
      begin
        vt = Mack::Rendering::ViewTemplate.new(:notifier, self.class.to_s.underscore, {:locals => {:notifier => self}, :format => format.to_s})
        return vt._compile_and_render
      rescue Mack::Errors::ResourceNotFound => e
      end
      return nil
    end
    
  end # Notifier
end # Mack