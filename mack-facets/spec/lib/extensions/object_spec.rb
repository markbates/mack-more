require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Object do
  
  describe "with_options" do
    
    before do
      class Regis
        needs_method :kelly
      end
    end
    
    it "should raise NoMethodError" do
      lambda{Regis.new.kelly}.should raise_error(NoMethodError)
    end
    
  end
  
  describe "class_parents" do
    
    it "should return an Array of Class objects for a class, ordered by ancestory" do
      Orange.new.class_parents == [Citrus, Fruit, Object]
      Fruit.new.class_parents == [Object]
    end
    
  end
  
  describe "to_param" do
    
  end
  
  describe "needs_method" do
    
  end
  
  describe "running_time" do
    
  end
  
  describe "send_with_chain" do
    
  end
  
  describe "ivar_cache" do
    
  end
  
  describe "ivar_cache_clear" do
    
  end
  
  describe "namespaces" do
    
  end
  
end