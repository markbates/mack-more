require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Object do
  
  class Boat
  end
  
  class Car
  end
  
  module BoatMethods
    def foo
    end
  end
  
  module CarMethods
    def bar
    end
  end
  
  describe 'defined_instance_method' do
    
    class Foo

      def initialize(options = {})
        options.each do |k,v|
          define_instance_method(k) do |m|
            v * m
          end
        end
      end

    end
    
    it 'should create a method for that instance only' do
      f1 = Foo.new(:bar => 1)
      f2 = Foo.new(:bar => 2)
      f1.bar(10).should == 10
      f2.bar(20).should == 40
      f1.define_instance_method(:me) do
        'mark'
      end
      f1.me.should == 'mark'
      lambda {f2.me}.should raise_error(NoMethodError)
    end
    
  end
  
  describe "safely_include_module" do
    
    it "should include a single modules methods as protected" do
      Boat.public_instance_methods.should_not include("foo")
      class Boat
        safely_include_module(BoatMethods)
      end
      Boat.public_instance_methods.should_not include("foo")
      Boat.protected_instance_methods.should include("foo")
    end
    
    it "should include multiple modules methods as protected" do
      Car.public_instance_methods.should_not include("foo")
      Car.public_instance_methods.should_not include("bar")
      class Car
        safely_include_module(BoatMethods, CarMethods)
      end
      Car.public_instance_methods.should_not include("foo")
      Car.public_instance_methods.should_not include("bar")
      Car.protected_instance_methods.should include("foo")
      Car.protected_instance_methods.should include("bar")
    end
    
  end
  
  describe "with_options" do
    
    it "should append the given hash onto the end of the method called" do
      route = Route.new
      route.with_options(:controller => :users) do |r|
        r.add(:action => :index)
      end
      route.list.should have(1).item
      route.list.should include({:controller => :users, :action => :index})
      route.with_options(:controller => :posts) do |r|
        r.add(:action => :new)
      end
      route.list.should have(2).items
      route.list.first.should == {:controller => :users, :action => :index}
      route.list.last.should == {:controller => :posts, :action => :new}
    end
    
  end
  
  describe "class_parents" do
    
    it "should return an Array of Class objects for a class, ordered by ancestory" do
      Orange.new.class_parents == [Citrus, Fruit, Object]
      Fruit.new.class_parents == [Object]
    end
    
  end
  
  describe "to_param" do
    
    it "should return to_s by default" do
      "hello".to_param.should == "hello"
      Orange.new.to_param.should == "I'm an Orange"
    end
    
  end
  
  describe "needs_method" do
    
    before do
      class Regis
        needs_method :kelly
      end
    end
    
    it "should raise NoMethodError" do
      lambda{Regis.new.kelly}.should raise_error(NoMethodError)
    end
    
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
    dog = Animals::Dog.new 
    dog.namespaces.should == ["Animals"]
    poodle = Animals::Dog::Poodle.new
    poodle.namespaces.should == ["Animals", "Dog"]
  end
  
end