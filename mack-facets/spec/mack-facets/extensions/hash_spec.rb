require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Hash do

  before(:each) do
    @test_hash = {:a => "aaa", :b => "bbb", :c => "ccc", :d => "ddd", :e => "eee", :f => "fff"}
  end
  
  describe "-" do
    
    it "should destructively removed elements in the Hash with the specified keys passed in as an array" do
      (@test_hash - [:a]).should == {:b => "bbb", :c => "ccc", :d => "ddd", :e => "eee", :f => "fff"}
      (@test_hash - [:b, :c]).should == {:d => "ddd", :e => "eee", :f => "fff"}
    end
    
    it "should destructively removed elements in the Hash with the specified keys passed in as a single param" do
      (@test_hash - :a).should == {:b => "bbb", :c => "ccc", :d => "ddd", :e => "eee", :f => "fff"}
    end
    
    it "should work just fine it doesn't contain the specified keys" do
      (@test_hash - :g).should == {:a => "aaa", :b => "bbb", :c => "ccc", :d => "ddd", :e => "eee", :f => "fff"}
      (@test_hash - [:g, :h]).should == {:a => "aaa", :b => "bbb", :c => "ccc", :d => "ddd", :e => "eee", :f => "fff"}
    end
    
  end
  
  describe "join" do
    
    it "should return a string formatted with the specified formatting parameters" do
      @test_hash.join("%s=\"%s\"", " ").should == "a=\"aaa\" b=\"bbb\" c=\"ccc\" d=\"ddd\" e=\"eee\" f=\"fff\""
    end
    
  end
  
  describe "to_params" do
    
    it "should convert the Hash to a string representing query string parameters" do
      {:a => "aaa", :b => "bbb", :c => "ccc"}.to_params.should == "a=aaa&b=bbb&c=ccc"
      {:a => "aaa", :b => "bbb", :c => "Hello World!"}.to_params.should == "a=aaa&b=bbb&c=Hello+World%21"
      {:one => "one", :two => "too", :three => 3}.to_params.should == "one=one&three=3&two=too"
    end
    
    it "should handle nested parameters" do
      {:a => "aaa", :b => {:one => "won", :two => "too"}}.to_params.should == "a=aaa&b[one]=won&b[two]=too"
    end
    
    it "should not escape the values if specified" do
      {:a => "aaa", :b => "bbb", :c => "Hello World!"}.to_params(false).should == "a=aaa&b=bbb&c=Hello World!"
    end
    
  end
  
end