module Mack # :nodoc:
  module Utils # :nodoc:
    # Include this module into any class, or module, and it's methods can become hookable.
    # This allows for the ability to do really nice AOP programming.
    # 
    # Example:
    #   class User
    #     def say_full_name
    #       puts "mark"
    #     end
    #   end
    #   User.before(:say_full_name) do
    #     puts "hello"
    #   end
    #   User.new.say_full_name # => "hello" "mark"
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
        }
        klass.extend self
      end

      # Used to prefix an instance method with the assigned block
      def before(name, &block)
        hookable_class.hooks_for(:before, name.to_sym) << block
        build_hook_instance_method(name)
      end
      
      # Used to suffix an instance method with the assigned block
      def after(name, &block)
        hookable_class.hooks_for(:after, name.to_sym) << block
        build_hook_instance_method(name)
      end
      
      # Used to prefix a class method with the assigned block
      def before_class_method(name, &block)
        hookable_class.hooks_for(:before_class_method, name.to_sym) << block
        build_hook_class_method(name)
      end
      
      # Used to suffix a class method with the assigned block
      def after_class_method(name, &block)
        hookable_class.hooks_for(:after_class_method, name.to_sym) << block
        build_hook_class_method(name)
      end
      
      def hookable_class
        if self.instance_of?(Module) || self.instance_of?(Class)
          "#{self}::Hooks".constantize.instance
        else
          "#{self.class}::Hooks".constantize.instance
        end
      end
      
      private
      def build_hook_instance_method(name)
        unless self.public_instance_methods.include?("hookable_#{name}")
          class_eval do
            alias_method "hookable_#{name}", name
            eval %{
              def #{name}(*args, &block)
                hookable_class.hooks_for(:before, :#{name}).each do |p|
                  p.call
                end
                hookable_#{name}(*args, &block)
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
                def #{name}(*args, &block)
                  hookable_class.hooks_for(:before_class_method, :#{name}).each do |p|
                    p.call
                  end
                  self.hookable_#{name}(*args, &block)
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