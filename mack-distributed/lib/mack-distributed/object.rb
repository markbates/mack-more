module Mack
  module Distributed # :nodoc:
    module Object
      
      def self.included(base)
        if app_config.mack.share_objects
          base.class_eval do
            include ::DRbUndumped
          end
          eval %{
            class ::Mack::Distributed::#{base}Proxy
              include Singleton
              include DRbUndumped

              def method_missing(sym, *args)
                #{base}.send(sym, *args)
              end
            
              # def respond_to?(sym)
              #   #{base}.respond_to?(sym)
              # end
            end
          }
          raise Mack::Distributed::Errors::ApplicationNameUndefined.new if app_config.mack.distributed_app_name.nil?
          Mack::Distributed::Utils::Rinda.register_or_renew(:space => app_config.mack.distributed_app_name.to_sym, 
                                                            :klass_def => "#{base}".to_sym, 
                                                            :object => "Mack::Distributed::#{base}Proxy".constantize.instance)
        end
      end
      
    end # Object
  end # Distributed
end # Mack