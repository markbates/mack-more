require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Array do
  
  describe "parse_splat_args" do
    
    it "should return an array from an array" do
      foo(1,2,3).should == [1,2,3]
      foo([1,2,3]).should == [1,2,3]
    end
    
    it "should return a single value from a single value" do
      foo(1).should == 1
    end
    
    it "should return a hash from a hash value" do
      foo({:mack => "is cool"}).should == {:mack => "is cool"}
    end
    
    it "should return nil from a nil value" do
      foo(nil).should == nil
    end
    
  end
  
  describe "randomize" do
    
    before do
      @r_array = [1,2,3,4,5]
    end
    
    it "should non-destructively randomize an array" do
      @r_array.randomize.should_not == @r_array
    end
    
    describe "!" do
      
      it "should destructively randomize an array" do
        @r_array.randomize!
        @r_array.should_not == [1,2,3,4,5]
      end
      
    end
    
  end
  
  def foo(*args)
    return args.parse_splat_args
  end
  
end