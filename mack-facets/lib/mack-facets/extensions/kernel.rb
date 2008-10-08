require 'pp'
require 'stringio'

module Kernel
  
  def run_once
    path = File.expand_path(caller.first)
    unless ($__already_run_block ||= []).include?(path)
      yield
      $__already_run_block << path
    end
    puts "$__already_run_block: #{$__already_run_block}"
  end
  
  # Aliases an instance method to a new name. It will only do the aliasing once, to prevent
  # issues with reloading a class and causing a StackLevel too deep error.
  # The method takes two arguments, the first is the original name of the method, the second,
  # optional, parameter is the new name of the method. If you don't specify a new method name
  # it will be generated with _original_<original_name>.
  # 
  # Example:
  #   class Popcorn < Corn
  #     alias_instance_method :poppy
  #     alias_instance_method :corny, :old_corny
  #     def poppy
  #       2 * _original_poppy
  #     end
  #     def corny
  #       'pop' + old_corny
  #     end
  #   end
  def alias_instance_method(orig_name, new_name = "_original_#{orig_name}")
    alias_method new_name.to_sym, orig_name.to_sym unless method_defined?(new_name.to_s)
  end
  
  # Aliases a class method to a new name. It will only do the aliasing once, to prevent
  # issues with reloading a class and causing a StackLevel too deep error.
  # The method takes two arguments, the first is the original name of the method, the second,
  # optional, parameter is the new name of the method. If you don't specify a new method name
  # it will be generated with _original_<original_name>.
  # 
  # Example:
  #   class President
  #     alias_class_method :good
  #     alias_class_method :bad, :old_bad
  #     def self.good
  #       'Bill ' + _original_good
  #     end
  #     def self.bad
  #       "Either #{old_bad}"
  #     end
  #   end
  def alias_class_method(orig_name, new_name = "_original_#{orig_name}")
    eval(%{
      class << self
        alias_method :#{new_name}, :#{orig_name} unless method_defined?("#{new_name}")
      end
    })
  end
  
  def pp_to_s(object)
    pp_out = StringIO.new
    PP.pp(object,pp_out)
    return pp_out.string
  end
  
  def retryable(options = {}, &block)
    opts = { :tries => 1, :on => Exception }.merge(options)

    retries = opts[:tries]
    retry_exceptions = [opts[:on]].flatten
    
    x = %{
      begin
        return yield
      rescue #{retry_exceptions.join(", ")} => e
        retries -= 1
        if retries > 0
          retry
        else
          raise e
        end
      end        
    }

    eval(x, &block)
  end
  
  # Returns true/false if the current version of Ruby equals the specified version
  def ruby?(v)
    RUBY_VERSION == v
  end
  
end
