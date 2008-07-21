require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Utils::Registry do

  class FooRegistry < Mack::Utils::Registry
  end
  
  class BarRegistry < Mack::Utils::Registry
    def initial_state
      [1,2,3]
    end
  end
  
  before(:each) do
    FooRegistry.reset!
    BarRegistry.reset!
  end
  
  describe "self.registered_items" do
    
    it "should return the list of registered items" do
      FooRegistry.registered_items.should == []
      FooRegistry.registered_items << 1
      FooRegistry.registered_items.should == [1]
    end
    
  end
  
  describe "self.add" do
    
    it "should add a object only once" do
      BarRegistry.registered_items.should == [1,2,3]
      BarRegistry.add(1)
      BarRegistry.registered_items.should == [1,2,3]
    end
    
    it "should allow for a object to be inserted anywhere in the list" do
      BarRegistry.registered_items.should == [1,2,3]
      BarRegistry.add(4, 1)
      BarRegistry.registered_items.should == [1,4,2,3]
    end
    
  end
  
  describe "self.remove" do
    
    it "should remove an object from the list" do
      BarRegistry.registered_items.should == [1,2,3]
      BarRegistry.remove(2)
      BarRegistry.registered_items.should == [1,3]
    end
  end
  
  describe "self.move_to_top" do
    
    it "should move an object to the top of the list" do
      BarRegistry.registered_items.should == [1,2,3]
      BarRegistry.move_to_top(2)
      BarRegistry.registered_items.should == [2,1,3]
    end
    
  end
  
  describe "self.move_to_bottom" do
    it "should move an object to the bottom of the list" do
      BarRegistry.registered_items.should == [1,2,3]
      BarRegistry.move_to_bottom(2)
      BarRegistry.registered_items.should == [1,3,2]
    end
  end
  
end