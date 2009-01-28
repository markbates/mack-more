require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Utils::RegistryMap do

  class FooMap < Mack::Utils::RegistryMap
  end
  
  class BarMap < Mack::Utils::RegistryMap
    def initial_state
      { :hello => [1,2,3] }
    end
  end
  
  before(:each) do
    FooMap.reset!
    BarMap.reset!
  end
  
  describe "self.registered_items" do
    
    it "should return the list of registered items" do
      FooMap.registered_items.should == {}
      FooMap.add(:tag1, 1)
      FooMap.registered_items.should == {:tag1 => [1]}
    end
    
  end
  
  describe "self.add" do
    
    it "should add a object only once" do
      BarMap.registered_items.should == { :hello => [1,2,3] }
      BarMap.add(:hello, 1)
      BarMap.registered_items.should == { :hello => [1,2,3] } 
    end
    
    it "should add object to new tag" do
      BarMap.registered_items.should == { :hello => [1,2,3] }
      BarMap.add(:world, 4)
      BarMap.registered_items.should == { :hello => [1,2,3], :world => [4] }
    end
    
    it "should allow for a object to be inserted anywhere in the list in the map" do
      BarMap.registered_items.should == { :hello => [1,2,3] }
      BarMap.add(:hello, 4, 1)
      BarMap.registered_items.should == { :hello => [1,4,2,3] }
    end
    
  end
  
  describe "self.remove" do
    
    it "should remove an object from the list" do
      BarMap.registered_items.should == { :hello => [1,2,3] }
      BarMap.remove(:hello, 2)
      BarMap.registered_items.should == { :hello => [1,3] }
    end
  end
  
  describe "self.move_to_top" do
    
    it "should move an object to the top of the list" do
      BarMap.registered_items.should == { :hello => [1,2,3] }
      BarMap.move_to_top(:hello, 2)
      BarMap.registered_items.should == { :hello => [2,1,3] }
    end
    
  end
  
  describe "self.move_to_bottom" do
    it "should move an object to the bottom of the list" do
      BarMap.registered_items.should == { :hello => [1,2,3] }
      BarMap.move_to_bottom(:hello, 2)
      BarMap.registered_items.should == { :hello => [1,3,2] }
    end
  end
  
end