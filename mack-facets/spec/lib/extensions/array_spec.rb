require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Array do
  
  describe 'include?' do
    
    it 'should also work with Regexs' do
      a = ['mark', 'bates']
      a.should be_include('mark')
      a.should be_include(/ar/)
    end
    
  end
  
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
      foo(nil).should be_nil
    end
    
    def foo(*args)
      return args.parse_splat_args
    end
    
  end
  
  describe "randomize" do
    
    before do
      @r_array = [1,2,3,4,5,6,7,8,9,10]
    end
    
    it "should non-destructively randomize an array" do
      @r_array.randomize.should_not == @r_array
    end
    
    describe "!" do
      
      it "should destructively randomize an array" do
        @r_array.randomize!
        @r_array.should_not == [1,2,3,4,5,6,7,8,9,10]
      end
      
    end
    
  end
  
  describe "pick_random" do
    
    it "should pick a random value from an array" do
      a = (0..1000).to_a
      a.pick_random.should_not == 0
    end
    
  end
  
  describe "random_each" do
    a = (0..1000).to_a
    b = []
    a.random_each {|i| b << i}
    a.should_not == b
  end
  
  describe "subset?" do
    
    before(:all) do
      @subset_a = [1,2,3,4,5]
      @subset_b = [2,3] 
    end
    
    it "should return true if the second array is a subset of the first array" do
      @subset_b.subset?(@subset_a).should be_true
    end
    
    it "should return true if the two arrays are equal" do
      @subset_b.subset?(@subset_b).should be_true
    end
    
    it "should return false if the second array is not a subset of the first array" do
      @subset_a.subset?(@subset_b).should be_false
    end
    
  end
  
  describe "count" do
    
    it "should return a hash containing the count of each item in the array" do
      a = %w{spam spam eggs ham eggs spam}
      a.count.should == {"eggs" => 2, "ham" => 1, "spam" => 3}
    end
    
  end
  
  describe "invert" do
    
    it "should return a hash with the key being the array value and the value being the array index" do
      a = %w{red yellow orange}
      a.invert.should == {"red" => 0, "orange" => 2, "yellow" => 1}
    end
    
  end
  
end