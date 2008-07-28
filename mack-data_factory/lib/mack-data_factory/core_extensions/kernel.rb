module Mack
  module Data
    class FactoryRegistryMap < Mack::Utils::RegistryMap
    end
  end
end

module Kernel
  
  def factories(tag, &block)
    raise "factories: block needed" if !block_given?
    fact_registry.add(tag, block)
  end
  
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