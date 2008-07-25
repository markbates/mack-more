module Mack
  module Mailer
    module Validatable

      def self.included(base)
        base.instance_eval do
          include ::Validatable
          alias_method :"unvalidated_deliver!", :"deliver!"
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
            
            def common_mailer_validations
              validates_presence_of :to
              validates_presence_of :from
              validates_presence_of :subject
            end
            
          end # class << self
        end # class_eval
      end # included
      
      def deliver!(handler = app_config.mailer.deliver_with)
        raise 'Email is Invalid!' unless self.valid?
        unvalidated_deliver!(handler)
      end
      
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