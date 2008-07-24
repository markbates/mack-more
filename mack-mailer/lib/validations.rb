module Mack
  module Mailer
    module Validatable

      def self.included(base)
        base.instance_eval do
          include ::Validatable
          # alias_method :unvalidated_deliver, :deliver
          alias_method :"unvalidated_deliver!", :"deliver!"
        end
      end
      
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