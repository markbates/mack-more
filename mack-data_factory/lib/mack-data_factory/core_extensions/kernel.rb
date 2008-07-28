module Mack
  module Data
    class FactoryRegistryMap < Mack::Utils::RegistryMap
    end
  end
end

module Kernel
  
  #
  # Convenient routine to create an execution chain of factories
  #
  # Example:
  #     factories(:foo) do
  #         UserFactory.create(1)
  #         UserFactory.create(2, :diff_firstname)
  #     end
  #
  # Then to execute the chains, you'll need to call run_factories, and
  # pass in the name of the chain you want to execute.  
  #
  # Example:
  #     run_factories(:foo)
  #
  # @tag -- the name of the factory chain
  # @block -- the proc to be executed later
  #
  def factories(tag, &block)
    raise "factories: block needed" if !block_given?
    fact_registry.add(tag, block)
  end
  
  #
  # Run defined factory chain
  #
  # @see factories
  # @tag -- the name of the factory chain to be run
  # @return true if successful, false otherwise
  def run_factories(tag)
    runners = fact_registry.registered_items[tag]
    return false if runners == nil
    
    runners.each do |r|
      r.call
    end
    
    return true
  end
  
  private
  def fact_registry
    Mack::Data::FactoryRegistryMap.instance
  end
  
end