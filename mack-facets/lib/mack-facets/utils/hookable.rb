#--
# TODO: Remove this once Extlib 0.9.3 comes out!
#--
module Extlib #:nodoc:
  
  module Assertions # :nodoc:
    def assert_kind_of(name, value, *klasses)
      klasses.each { |k| return if value.kind_of?(k) }
      raise ArgumentError, "+#{name}+ should be #{klasses.map { |k| k.name } * ' or '}, but was #{value.class.name}", caller(2)
    end
  end
  
  #
  # TODO: Write more documentation!
  #
  # Overview
  # ========
  #
  # The Hook module is a very simple set of AOP helpers. Basically, it
  # allows the developer to specify a method or block that should run
  # before or after another method.
  #
  # Usage
  # =====
  #
  # Halting The Hook Stack
  #
  # Inheritance
  #
  # Other Goodies
  #
  # Please bring up any issues regarding Hooks with carllerche on IRC
  #
  module Hook # :nodoc:

    def self.included(base)
      base.extend(ClassMethods)
      base.const_set("CLASS_HOOKS", {}) unless base.const_defined?("CLASS_HOOKS")
      base.const_set("INSTANCE_HOOKS", {}) unless base.const_defined?("INSTANCE_HOOKS")
      base.class_eval do
        class << self
          def method_added(name)
            process_method_added(name, :instance)
          end
          
          def singleton_method_added(name)
            process_method_added(name, :class)
          end
        end
      end
    end

    module ClassMethods # :nodoc:
      include Extlib::Assertions
      # Inject code that executes before the target class method.
      #
      # @param target_method<Symbol>  the name of the class method to inject before
      # @param method_sym<Symbol>     the name of the method to run before the
      #   target_method
      # @param block<Block>           the code to run before the target_method
      #
      # @note
      #   Either method_sym or block is required.
      # -
      # @api public
      def before_class_method(target_method, method_sym = nil, &block)
        install_hook :before, target_method, method_sym, :class, &block
      end

      #
      # Inject code that executes after the target class method.
      #
      # @param target_method<Symbol>  the name of the class method to inject after
      # @param method_sym<Symbol>     the name of the method to run after the target_method
      # @param block<Block>           the code to run after the target_method
      #
      # @note
      #   Either method_sym or block is required.
      # -
      # @api public
      def after_class_method(target_method, method_sym = nil, &block)
        install_hook :after, target_method, method_sym, :class, &block
      end

      #
      # Inject code that executes before the target instance method.
      #
      # @param target_method<Symbol>  the name of the instance method to inject before
      # @param method_sym<Symbol>     the name of the method to run before the
      #   target_method
      # @param block<Block>           the code to run before the target_method
      #
      # @note
      #   Either method_sym or block is required.
      # -
      # @api public
      def before(target_method, method_sym = nil, &block)
        install_hook :before, target_method, method_sym, :instance, &block
      end

      #
      # Inject code that executes after the target instance method.
      #
      # @param target_method<Symbol>  the name of the instance method to inject after
      # @param method_sym<Symbol>     the name of the method to run after the
      #   target_method
      # @param block<Block>           the code to run after the target_method
      #
      # @note
      #   Either method_sym or block is required.
      # -
      # @api public
      def after(target_method, method_sym = nil, &block)
        install_hook :after, target_method, method_sym, :instance, &block
      end

      # Register a class method as hookable. Registering a method means that
      # before hooks will be run immedietly before the method is invoked and
      # after hooks will be called immedietly after the method is invoked.
      #
      # @param hookable_method<Symbol> The name of the class method that should
      #   be hookable
      # -
      # @api public
      def register_class_hooks(*hooks)
        hooks.each { |hook| register_hook(hook, :class) }
      end

      # Register aninstance method as hookable. Registering a method means that
      # before hooks will be run immedietly before the method is invoked and
      # after hooks will be called immedietly after the method is invoked.
      #
      # @param hookable_method<Symbol> The name of the instance method that should
      #   be hookable
      # -
      # @api public
      def register_instance_hooks(*hooks)
        hooks.each { |hook| register_hook(hook, :instance) }
      end

      # Not yet implemented
      def reset_hook!(target_method, scope)
        raise NotImplementedError
      end

      # --- Alright kids... the rest is internal stuff ---

      # Returns the correct HOOKS Hash depending on whether we are
      # working with class methods or instance methods
      def hooks_with_scope(scope)
        case scope
          when :class    then class_hooks
          when :instance then instance_hooks
          else raise ArgumentError, 'You need to pass :class or :instance as scope'
        end
      end

      def class_hooks
        self.const_get("CLASS_HOOKS")
      end

      def instance_hooks
        self.const_get("INSTANCE_HOOKS")
      end

      # Registers a method as hookable. Registering hooks involves the following
      # process
      #
      # * Create a blank entry in the HOOK Hash for the method.
      # * Define the methods that execute the before and after hook stack.
      #   These methods will be no-ops at first, but everytime a new hook is
      #   defined, the methods will be redefined to incorporate the new hook.
      # * Redefine the method that is to be hookable so that the hook stacks
      #   are invoked approprietly.
      def register_hook(target_method, scope)
        if scope == :instance && !method_defined?(target_method)
          raise ArgumentError, "#{target_method} instance method does not exist"
        elsif scope == :class && !respond_to?(target_method)
          raise ArgumentError, "#{target_method} class method does not exist"
        end

        hooks = hooks_with_scope(scope)

        if hooks[target_method].nil?
          hooks[target_method] = {
            # We need to keep track of which class in the Inheritance chain the
            # method was declared hookable in. Every time a child declares a new
            # hook for the method, the hook stack invocations need to be redefined
            # in the original Class. See #define_hook_stack_execution_methods
            :before => [], :after => [], :in => self
          }

          define_hook_stack_execution_methods(target_method, scope)
          define_advised_method(target_method, scope)
        end
      end

      # Is the method registered as a hookable in the given scope.
      def registered_as_hook?(target_method, scope)
        ! hooks_with_scope(scope)[target_method].nil?
      end

      # Generates names for the various utility methods. We need to do this because
      # the various utility methods should not end in = so, while we're at it, we
      # might as well get rid of all punctuation.
      def hook_method_name(target_method, prefix, suffix)
        target_method = target_method.to_s

        case target_method[-1,1]
          when '?' then "#{prefix}_#{target_method[0..-2]}_ques_#{suffix}"
          when '!' then "#{prefix}_#{target_method[0..-2]}_bang_#{suffix}"
          when '=' then "#{prefix}_#{target_method[0..-2]}_eq_#{suffix}"
          # I add a _nan_ suffix here so that we don't ever encounter
          # any naming conflicts.
          else "#{prefix}_#{target_method[0..-1]}_nan_#{suffix}"
        end
      end
      
      # This will need to be refactored
      def process_method_added(method_name, scope)
        hooks_with_scope(scope).each do |target_method, hooks|
          if hooks[:before].any? { |hook| hook[:name] == method_name }
            define_hook_stack_execution_methods(target_method, scope)
          end
          
          if hooks[:after].any? { |hook| hook[:name] == method_name }
            define_hook_stack_execution_methods(target_method, scope)
          end
        end
      end

      # Defines two methods. One method executes the before hook stack. The other executes
      # the after hook stack. This method will be called many times during the Class definition
      # process. It should be called for each hook that is defined. It will also be called
      # when a hook is redefined (to make sure that the arity hasn't changed).
      def define_hook_stack_execution_methods(target_method, scope)
        unless registered_as_hook?(target_method, scope)
          raise ArgumentError, "#{target_method} has not be registered as a hookable #{scope} method"
        end

        hooks = hooks_with_scope(scope)

        before_hooks = hooks[target_method][:before]
        before_hooks = before_hooks.map{ |info| inline_call(info, scope) }.join("\n")

        after_hooks  = hooks[target_method][:after]
        after_hooks  = after_hooks.map{ |info| inline_call(info, scope) }.join("\n")

        source = %{
          private

          def #{hook_method_name(target_method, 'execute_before', 'hook_stack')}(*args)
            #{before_hooks}
          end

          def #{hook_method_name(target_method, 'execute_after', 'hook_stack')}(*args)
            #{after_hooks}
          end
        }

        source = %{class << self\n#{source}\nend} if scope == :class

        hooks[target_method][:in].class_eval(source, __FILE__, __LINE__)
      end

      # Returns ruby code that will invoke the hook. It checks the arity of the hook method
      # and passes arguments accordingly.
      def inline_call(method_info, scope)
        name = method_info[:name]
        
        if scope == :instance
          args = method_defined?(name) && instance_method(name).arity != 0 ? '*args' : ''
          %(#{name}(#{args}) if self.class <= ObjectSpace._id2ref(#{method_info[:from].object_id}))
        else
          args = respond_to?(name) && method(name).arity != 0 ? '*args' : ''
          %(#{name}(#{args}) if self <= ObjectSpace._id2ref(#{method_info[:from].object_id}))
        end
      end

      def define_advised_method(target_method, scope)
        args = args_for(method_with_scope(target_method, scope))

        renamed_target = hook_method_name(target_method, 'hookable_', 'before_advised')

        source = <<-EOD
          def #{target_method}(#{args})
            retval = nil
            catch(:halt) do
              #{hook_method_name(target_method, 'execute_before', 'hook_stack')}(#{args})
              retval = #{renamed_target}(#{args})
              #{hook_method_name(target_method, 'execute_after', 'hook_stack')}(retval, #{args})
              retval
            end
          end
        EOD

        if scope == :instance && !instance_methods(false).include?(target_method.to_s)
          send(:alias_method, renamed_target, target_method)

          proxy_module = Module.new
          proxy_module.class_eval(source, __FILE__, __LINE__)
          self.send(:include, proxy_module)
        else
          source = %{alias_method :#{renamed_target}, :#{target_method}\n#{source}}
          source = %{class << self\n#{source}\nend} if scope == :class
          class_eval(source, __FILE__, __LINE__)
        end
      end

      # --- Add a hook ---

      def install_hook(type, target_method, method_sym, scope, &block)
        assert_kind_of 'target_method', target_method, Symbol
        assert_kind_of 'method_sym',    method_sym,    Symbol unless method_sym.nil?
        assert_kind_of 'scope',         scope,         Symbol

        if !block_given? and method_sym.nil?
          raise ArgumentError, "You need to pass 2 arguments to \"#{type}\"."
        end

        if method_sym.to_s[-1,1] == '='
          raise ArgumentError, "Methods ending in = cannot be hooks"
        end

        unless [ :class, :instance ].include?(scope)
          raise ArgumentError, 'You need to pass :class or :instance as scope'
        end

        register_hook(target_method, scope) unless registered_as_hook?(target_method, scope)

        hooks = hooks_with_scope(scope)

        if block
          method_sym = "__hooks_#{type}_#{quote_method(target_method)}_#{hooks[target_method][type].length}".to_sym
          if scope == :class
            (class << self; self; end;).instance_eval do
              define_method(method_sym, &block)
            end
          else
            define_method(method_sym, &block)
          end
        end

        # Adds method to the stack an redefines the hook invocation method
        hooks[target_method][type] << { :name => method_sym, :from => self }
        define_hook_stack_execution_methods(target_method, scope)
      end

      # --- Helpers ---

      def args_for(method)
        if method.arity == 0
          "&block"
        elsif method.arity > 0
          "_" << (1 .. method.arity).to_a.join(", _") << ", &block"
        elsif (method.arity + 1) < 0
          "_" << (1 .. (method.arity).abs - 1).to_a.join(", _") << ", *args, &block"
        else
          "*args, &block"
        end
      end

      def method_with_scope(name, scope)
        case scope
          when :class    then method(name)
          when :instance then instance_method(name)
          else raise ArgumentError, 'You need to pass :class or :instance as scope'
        end
      end

      def quote_method(name)
        name.to_s.gsub(/\?$/, '_q_').gsub(/!$/, '_b_').gsub(/=$/, '_eq_')
      end
    end

  end
end


# module Mack # :nodoc:
#   module Utils # :nodoc:
#     # Include this module into any class, or module, and it's methods can become hookable.
#     # This allows for the ability to do really nice AOP programming.
#     # 
#     # Example:
#     #   class User
#     #     def say_full_name
#     #       puts "mark"
#     #     end
#     #   end
#     #   User.before(:say_full_name) do
#     #     puts "hello"
#     #   end
#     #   User.new.say_full_name # => "hello" "mark"
#     module Hookable
#       
#       def self.included(klass)
#         eval %{
#           class ::#{klass}::Hooks
#             include Singleton
#             def initialize
#               @hooks = {:before => {}, :after => {}, :before_class_method => {}, :after_class_method => {}}
#             end
#             def hooks_for(state, meth)
#               (@hooks[state.to_sym][meth.to_sym] ||= [])
#             end
#             def next_hook_for(state, meth)
#               ms = hooks_for(state, meth)
#               return "hook_\#{state}_\#{meth}_0".methodize if ms.empty?
#               return ms.last.succ.methodize
#             end
#           end
#         }
#         klass.extend self
#       end
# 
#       # Used to prefix an instance method with the assigned block
#       def before(name, &block)
#         build_hook_instance_method(:before, name, &block)
#       end
#       
#       # Used to suffix an instance method with the assigned block
#       def after(name, &block)
#         build_hook_instance_method(:after, name, &block)
#       end
#       
#       # Used to prefix a class method with the assigned block
#       def before_class_method(name, &block)
#         build_hook_class_method(:before_class_method, name, &block)
#       end
#       
#       # Used to suffix a class method with the assigned block
#       def after_class_method(name, &block)
#         build_hook_class_method(:after_class_method, name, &block)
#       end
#       
#       private
#       def hookable_class
#         if self.instance_of?(Module) || self.instance_of?(Class)
#           "#{self}::Hooks".constantize.instance
#         else
#           "#{self.class}::Hooks".constantize.instance
#         end
#       end
#       
#       
#       def build_hook_instance_method(state, name, &block)
#         m_name = hookable_class.next_hook_for(state, name)
#         define_method(m_name, &block)
#         hookable_class.hooks_for(state, name) << m_name
#         unless self.public_instance_methods.include?("hooked_#{name}")
#           class_eval do
#             alias_method "hooked_#{name}", name
#             eval %{
#               def #{name}(*args, &block)
#                 hookable_class.hooks_for(:before, :#{name}).each do |ms|
#                   self.send(ms, *args)
#                 end
#                 x = hooked_#{name}(*args, &block)
#                 hookable_class.hooks_for(:after, :#{name}).each do |ms|
#                   self.send(ms, *args)
#                 end
#                 x
#               end
#             }
#           end
#         end
#       end
#       
#       def build_hook_class_method(state, name, &block)
#         m_name = hookable_class.next_hook_for(state, name)
#         self.extend(Module.new do
#           define_method(m_name, &block)
#         end)
#         hookable_class.hooks_for(state, name) << m_name
#         unless self.public_methods.include?("hooked_#{name}")
#           class_eval do
#             eval %{
#               class << self
#                 alias_method :hooked_#{name}, :#{name}
#                 def #{name}(*args, &block)
#                   hookable_class.hooks_for(:before_class_method, :#{name}).each do |ms|
#                     self.send(ms, *args)
#                   end
#                   x = hooked_#{name}(*args, &block)
#                   hookable_class.hooks_for(:after_class_method, :#{name}).each do |ms|
#                     self.send(ms, *args)
#                   end
#                   x
#                 end
#               end
#             }
#           end
#         end
#       end
#       
#     end # Hookable
#   end # Utils
# end # Mack