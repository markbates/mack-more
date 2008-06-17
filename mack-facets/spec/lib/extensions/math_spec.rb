require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Math do
  
  describe "log2" do
    
    it "should return the log2 of a given number" do
      Math.log2(5).round_at(5).should == 2.32193
      Math.log2(25).round_at(5).should == 4.64386
    end
    
  end
  
  describe "min" do
    
    it "should return the smaller of the two numbers" do
      Math.min(2,5).should == 2
      Math.min(5,2).should == 2
      Math.min(2,2).should == 2
      Math.min(5.5,2).should == 2
      Math.min(2.5, 5.5).should == 2.5
    end
    
  end
  
  describe "max" do
    
    it "should return the larger of the two numbers" do
      Math.max(2,5).should == 5
      Math.max(5,2).should == 5
      Math.max(2,2).should == 2
      Math.max(5.5,2).should == 5.5
      Math.max(2.5, 5.5).should == 5.5
    end
    
  end
  
end