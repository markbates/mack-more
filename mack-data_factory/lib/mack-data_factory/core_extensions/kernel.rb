module Mack
  module Data
    class FactoryRegistryMap < Mack::Utils::RegistryMap # :nodoc:
    end
  end
end

module Kernel
  
  #
  # Convenient routine to create an execution chain of factories
  #
  # Example:
  #   factories(:foo) do
  #     UserFactory.create(1)
  #     UserFactory.create(2, :diff_firstname)
  #   end
  #
  # Then to execute the chains, you'll need to call run_factories, and
  # pass in the name of the chain you want to execute.  
  #
  #   run_factories(:foo)
  #
  # <i>Parameters:</i>
  #   tag: the name of the factory chain
  #   block: the proc to be executed later
  #
  def factories(tag, &block)
    raise "factories: block needed" if !block_given?
    fact_registry.add(tag, block)
  end
  
  #
  # Run defined factory chain defined using factories method.
  #
  # <i>Parameters:</i>
  #   tag: the name of the factory chain to be run
  #
  def run_factories(tag)
    runners = fact_registry.registered_items[tag]
    return false if runners == nil
    runners.each { |r| r.call }
    return true
  end
  
  private
  def fact_registry
    Mack::Data::FactoryRegistryMap.instance
  end
  
end