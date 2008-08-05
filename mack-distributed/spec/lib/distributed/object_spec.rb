require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")
require 'rinda/ring'
require 'rinda/tuplespace'

describe Mack::Distributed::Object do

  class Car
    include Mack::Distributed::Object
    
    def make
      "Toyota"
    end
    
    def self.buy
    end
    
  end

  it "should include DRbUndumped" do
    Car.new.should be_is_a(DRbUndumped)
  end
  
  it "should defined a proxy singleton" do
    lambda{Mack::Distributed::BoatProxy}.should raise_error(NameError)
    class Boat
      include Mack::Distributed::Object
    end
    lambda{
      Mack::Distributed::BoatProxy.instance.should_not be_nil
      Mack::Distributed::BoatProxy.instance.should be_is_a(DRbUndumped)
    }.should_not raise_error(NameError)
  end
  
  it "should respond with the methods of the underlying class" do
    car = Mack::Distributed::CarProxy.instance.new
    car.should be_is_a(Car)
    car.make.should == "Toyota"
    car.respond_to?(:make).should == true
    Mack::Distributed::CarProxy.instance.respond_to?(:buy).should == true
  end
  

end