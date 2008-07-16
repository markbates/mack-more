module Mack # :nodoc:
  module Utils # :nodoc:
    module Hookable
      
      def self.included(klass)
        eval %{
          class ::#{klass}::Hooks
            include Singleton
            def initialize
              @hooks = {:before => {}, :after => {}, :before_class_method => {}, :after_class_method => {}}
            end
            def hooks_for(state, meth)
              (@hooks[state.to_sym][meth.to_sym] ||= [])
            end
          end
          def hookable_class
            ::#{klass}::Hooks.instance
          end
        }
        klass.extend self
      end

      def before(name, &block)
        hookable_class.hooks_for(:before, name.to_sym) << block
        build_hook_instance_method(name)
      end
      
      def after(name, &block)
        hookable_class.hooks_for(:after, name.to_sym) << block
        build_hook_instance_method(name)
      end
      
      def before_class_method(name, &block)
        hookable_class.hooks_for(:before_class_method, name.to_sym) << block
        build_hook_class_method(name)
      end
      
      def after_class_method(name, &block)
        hookable_class.hooks_for(:after_class_method, name.to_sym) << block
        build_hook_class_method(name)
      end
      
      private
      def build_hook_instance_method(name)
        unless self.public_instance_methods.include?("hookable_#{name}")
          class_eval do
            alias_method "hookable_#{name}", name
            eval %{
              def #{name}(*args)
                hookable_class.hooks_for(:before, :#{name}).each do |p|
                  p.call
                end
                hookable_#{name}(*args)
                hookable_class.hooks_for(:after, :#{name}).each do |p|
                  p.call
                end
              end
            }
          end
        end
      end
      
      def build_hook_class_method(name)
        unless self.public_methods.include?("hookable_#{name}")
          class_eval do
            eval %{
              class << self
                alias_method :hookable_#{name}, :#{name}
                def #{name}(*args)
                  hookable_class.hooks_for(:before_class_method, :#{name}).each do |p|
                    p.call
                  end
                  self.hookable_#{name}(*args)
                  hookable_class.hooks_for(:after_class_method, :#{name}).each do |p|
                    p.call
                  end
                end
              end
            }
          end
        end
      end
      
    end # Hookable
  end # Utils
end # Mack