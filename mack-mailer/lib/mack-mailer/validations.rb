module Mack
  module Mailer
    # Includes the validatable gem into your Mailer.
    # http://validatable.rubyforge.org
    module Validatable

      def self.included(base)
        base.instance_eval do
          include ::Validatable
          alias_method "unvalidated_deliver!", "deliver!"
        end
        
        base.class_eval do
          
          class << self
            
            # Alias the Validatable methods to look like DataMapper methods,
            # if that's the kind of thing you're used to. :)
            alias_method :validates_is_accepted, :validates_acceptance_of
            alias_method :validates_is_confirmed, :validates_confirmation_of
            alias_method :validates_format, :validates_format_of
            alias_method :validates_length, :validates_length_of
            alias_method :validates_is_number, :validates_numericality_of
            alias_method :validates_present, :validates_presence_of
            
            # Adds common validations to your Mack::Mailer class.
            # These include:
            #   validates_presence_of :to
            #   validates_presence_of :from
            #   validates_presence_of :subject
            #   validates_email_format_of :to
            #   validates_email_format_of :from
            def common_mailer_validations
              validates_presence_of :to
              validates_presence_of :from
              validates_presence_of :subject
              validates_email_format_of :to
              validates_email_format_of :from
            end
            
            # Validates the email format of the column specified against the email_validation_regex method.
            # This will drill into arrays as well, if that's what your column is.
            def validates_email_format_of(column, options = {})
              options = {:logic => lambda{
                [send(column)].flatten.each_with_index do |addr, i|
                  errors.add(column, "[#{addr}] is not valid") unless addr.to_s.downcase.match(self.class.email_validation_regex)
                end
              }}.merge(options)
              validates_each :to, options
            end
            
            def email_validation_regex
              regex = <<-EOF
              [a-z0-9!#$\%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$\%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?
              EOF
              /#{regex.strip}/
            end
            
          end # class << self
        end # class_eval
      end # included
      
      # Raises a RuntimeError if the email you are trying to deliver is not valid.
      def deliver!(handler = app_config.mailer.deliver_with)
        raise 'Email is Invalid!' unless self.valid?
        unvalidated_deliver!(handler)
      end
      
      # Returns false if the email is not valid.
      # If the email is valid and an exception is raised when trying to deliver it
      # false is returned and the exception is added to the errors array, with the
      # key :deliver.
      def deliver(handler = app_config.mailer.deliver_with)
        return false unless self.valid?
        begin
          "Mack::Mailer::DeliveryHandlers::#{handler.to_s.camelcase}".constantize.deliver(self)
        rescue Exception => e
          self.errors.add(:deliver, e.message)
          return false
        end
        return true
      end
      
    end # Validatable
  end # Mailer
end # Mack

module Validatable # :nodoc:
  class ValidationBase #:nodoc:
    
    # This fixes a bug with reloading of Validatable classes.
    def raise_error_if_key_is_dup(klass) # :nodoc:
      vals = {}
      klass.validations.each do |v|
        vals[v.key] = v
      end
      klass.validations.clear
      vals.each do |k,v|
        klass.validations << v
      end
    end # raise_error_if_key_is_dup
    
  end # ValidationBase
end # Validatable