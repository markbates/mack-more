require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Class do
  
  describe "class_is_a?" do
    
    it "should return true if passed itself" do
      Orange.class_is_a?(Orange).should == true
    end
    
    it "should return false if the class is not part of the ancestor chain " do
      Orange.class_is_a?(Array).should_not == true
    end
    
    it "should return false if the class is lower in the ancestor chain" do
      Fruit.class_is_a?(Orange).should_not == true
    end
    
    it "should return true if the class is higher in the ancestor chain" do
      Orange.class_is_a?(Citrus).should == true
      Orange.class_is_a?(Fruit).should == true
    end
    
  end
  
  describe "new_instance_of" do
    
    it "should create a new instance of a class from a String" do
      Class.new_instance_of("Orange").is_a?(Orange)
    end
    
    it "should create a new instance of a class from a String with a module" do
      Class.new_instance_of("Animals::Dog").is_a?(Animals::Dog)
    end
    
  end
  
  describe "parents" do
    
    it "should return an Array of Class objects for a class, ordered by ancestory" do
      Orange.parents.should == [Citrus, Fruit, Object]
      Fruit.parents.should == [Object]
    end
    
    describe "class_parents" do
      
      it "should return an Array of Class objects for a class, ordered by ancestory" do
        Orange.new.class_parents == [Citrus, Fruit, Object]
        Fruit.new.class_parents == [Object]
      end
      
    end
    
  end
  
end