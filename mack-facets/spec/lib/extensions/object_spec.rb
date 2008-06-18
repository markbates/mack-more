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
    
    it "should call each successive method with the results of the last one" do
      Fruit.send_with_chain([:new, :get_citrus, :class]).should == Citrus
      Fruit.send_with_chain([:new, :get_citrus, :get_orange, :class]).should == Orange
    end
    
  end
  
  describe "ivar_cache" do
    
    before do
      @foo = nil
    end
    
    it "should store the results of the block in an instance variable" do
      ivar_cache("foo") do
        "hello world"
      end.should == "hello world"
      @foo.should == "hello world"
    end
    
    it "should use the name of the method as the instance variable name" do
      o = Orange.new
      o.instance_variable_get("@say_hi").should be_nil
      o.say_hi("hi").should == "hi"
      o.instance_variable_get("@say_hi").should == "hi"
      o.say_hi("hi there").should == "hi"      
    end
    
    # assert @foo.nil?
    # ivar_cache("foo") do
    #   "hello world"
    # end
    # assert_equal "hello world", @foo
    # o = Orange.new
    # assert_equal 10, o.add(3, 7)
    # assert_equal 10, o.instance_variable_get("@results")
    # assert_equal 10, o.add(33, 17)
    # assert_equal 10, o.instance_variable_get("@results")
    # o.ivar_cache_clear("results")
    # assert o.instance_variable_get("@results").nil?
    # assert_equal "hello world", o.say_hi("hello world")
    # assert_equal "hello world", o.say_hi("hello world, again")
    # assert_equal "hello world", o.instance_variable_get("@say_hi")
  end
  
  describe "ivar_cache_clear" do
    
    it "should clear an instance variable set by ivar_cache" do
      o = Orange.new
      o.instance_variable_get("@results").should be_nil
      o.add(3, 7).should == 10
      o.instance_variable_get("@results").should be == 10
      o.ivar_cache_clear("results")
      o.instance_variable_get("@results").should be_nil
    end
    
  end
  
  describe "namespaces" do
    
  end
  
end