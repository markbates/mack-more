module Mack
  module Notifier
    # Includes the validatable gem into your Notifier.
    # http://validatable.rubyforge.org
    module Validatable

      def self.included(base)
        base.instance_eval do
          include ::Validatable
          alias_method "unvalidated_deliver!", "deliver!"
        end
        
        base.class_eval do

          # Alias the Validatable methods to look like DataMapper methods,
          # if that's the kind of thing you're used to. :)          
          alias_class_method :validates_acceptance_of, :validates_is_accepted
          alias_class_method :validates_confirmation_of, :validates_is_confirmed
          alias_class_method :validates_format_of, :validates_format
          alias_class_method :validates_length_of, :validates_length
          alias_class_method :validates_numericality_of, :validates_is_number
          alias_class_method :validates_presence_of, :validates_present
          
          class << self
            
            # Adds common validations to your Mack::Notifier class.
            # These include:
            #   validates_presence_of :to
            #   validates_presence_of :from
            #   validates_presence_of :subject
            #   validates_email_format_of :to
            #   validates_email_format_of :from
            def common_notifier_validations
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
      def deliver!(handler = deliver_with)
        raise 'Notification is Invalid!' unless self.valid?
        unvalidated_deliver!(handler)
      end
      
      # Returns false if the email is not valid.
      # If the email is valid and an exception is raised when trying to deliver it
      # false is returned and the exception is added to the errors array, with the
      # key :deliver.
      def deliver(handler = deliver_with)
        return false unless self.valid?
        begin
          "Mack::Notifier::DeliveryHandlers::#{handler.to_s.camelcase}".constantize.deliver(self)
        rescue Exception => e
          self.errors.add(:deliver, e.message)
          return false
        end
        return true
      end
      
      def errors_for(name)
        self.errors.on(name.to_sym)
      end
      
    end # Validatable
  end # Notifier
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