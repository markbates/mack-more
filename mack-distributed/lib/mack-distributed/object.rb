module Mack
  module Distributed # :nodoc:
    module Object
      
      def self.included(base)
        base.class_eval do
          include ::DRbUndumped
        end
        eval %{
          class ::Mack::Distributed::#{base}Proxy < Mack::Utils::BlankSlate
            include Singleton
            include DRbUndumped

            def method_missing(sym, *args)
              #{base}.send(sym, *args)
            end
          end
        }
      end
      
    end # Object
  end # Distributed
end # Mack