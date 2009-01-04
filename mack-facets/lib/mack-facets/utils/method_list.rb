module Mack # :nodoc:
  module Utils # :nodoc:
    class MethodList
      
      def initialize(array)
        @__array = array
      end
      
      def include?(name)
        @__array.include?(v1_9? ? name.to_sym : name.to_s)
      end
      
      def method_missing(sym, *args)
        @__array.send(sym, *args)
      end
      
    end # MethodList
  end # Utils
end # Mack

module Mack # :nodoc:
  module Utils # :nodoc:
    module MethodListExtensions # :nodoc:
      
      run_once do
        ["instance_methods", "methods", "private_instance_methods", "private_methods", "protected_instance_methods", "protected_methods", "public_instance_methods", "public_methods", "singleton_methods"].each do |m_name|
          begin
            eval %{
              alias_method :__original_#{m_name}, :#{m_name}
            
              def #{m_name}(*args)
                Mack::Utils::MethodList.new(__original_#{m_name}(*args))
              end
            }
          rescue Exception => e
          end
        end
      end
      
    end # MethodListExtensions
  end # Utils
end # Mack

run_once do
  class Object # :nodoc:
    include Mack::Utils::MethodListExtensions
    extend Mack::Utils::MethodListExtensions
  end
end