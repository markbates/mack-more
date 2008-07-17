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
            def next_hook_for(state, meth)
              ms = hooks_for(state, meth)
              return "hook_\#{state}_\#{meth}_0".methodize if ms.empty?
              return ms.last.succ.methodize
            end
          end
        }
        klass.extend self
      end

      # Used to prefix an instance method with the assigned block
      def before(name, &block)
        build_hook_instance_method(:before, name, &block)
      end
      
      # Used to suffix an instance method with the assigned block
      def after(name, &block)
        build_hook_instance_method(:after, name, &block)
      end
      
      # Used to prefix a class method with the assigned block
      def before_class_method(name, &block)
        build_hook_class_method(:before_class_method, name, &block)
      end
      
      # Used to suffix a class method with the assigned block
      def after_class_method(name, &block)
        build_hook_class_method(:after_class_method, name, &block)
      end
      
      private
      def hookable_class
        if self.instance_of?(Module) || self.instance_of?(Class)
          "#{self}::Hooks".constantize.instance
        else
          "#{self.class}::Hooks".constantize.instance
        end
      end
      
      
      def build_hook_instance_method(state, name, &block)
        m_name = hookable_class.next_hook_for(state, name)
        define_method(m_name, &block)
        hookable_class.hooks_for(state, name) << m_name
        unless self.public_instance_methods.include?("hooked_#{name}")
          class_eval do
            alias_method "hooked_#{name}", name
            eval %{
              def #{name}(*args, &block)
                hookable_class.hooks_for(:before, :#{name}).each do |ms|
                  self.send(ms, *args)
                end
                x = hooked_#{name}(*args, &block)
                hookable_class.hooks_for(:after, :#{name}).each do |ms|
                  self.send(ms, *args)
                end
                x
              end
            }
          end
        end
      end
      
      def build_hook_class_method(state, name, &block)
        m_name = hookable_class.next_hook_for(state, name)
        self.extend(Module.new do
          define_method(m_name, &block)
        end)
        hookable_class.hooks_for(state, name) << m_name
        unless self.public_methods.include?("hooked_#{name}")
          class_eval do
            eval %{
              class << self
                alias_method :hooked_#{name}, :#{name}
                def #{name}(*args, &block)
                  hookable_class.hooks_for(:before_class_method, :#{name}).each do |ms|
                    self.send(ms, *args)
                  end
                  x = hooked_#{name}(*args, &block)
                  hookable_class.hooks_for(:after_class_method, :#{name}).each do |ms|
                    self.send(ms, *args)
                  end
                  x
                end
              end
            }
          end
        end
      end
      
    end # Hookable
  end # Utils
end # Mack