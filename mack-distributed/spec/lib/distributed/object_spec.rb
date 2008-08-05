require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")
require 'rinda/ring'
require 'rinda/tuplespace'

describe Mack::Distributed::Object do

  before(:each) do
    begin
      DRb.start_service
      Rinda::RingServer.new(Rinda::TupleSpace.new)
    rescue Errno::EADDRINUSE => e
      # it's fine to ignore this, it's expected that it's already running.
      # all other exceptions should be thrown
    end
  end

  it "should include DRbUndumped" do
    class Pool
      include Mack::Distributed::Object
    end
    Pool.new.should be_is_a(DRbUndumped)
  end
  
  it "should defined a proxy singleton" do
    lambda{Mack::Distributed::BoatProxy}.should raise_error(Rinda::RequestExpiredError)
    class Boat
      include Mack::Distributed::Object
    end
    lambda{
      Mack::Distributed::BoatProxy.instance.should_not be_nil
      Mack::Distributed::BoatProxy.instance.should be_is_a(DRbUndumped)
    }.should_not raise_error(NameError)
  end
  
  it "should respond with the methods of the underlying class" do
    class Car
      include Mack::Distributed::Object
      def make
        "Toyota"
      end
      def self.buy
        true
      end
    end
    car = Mack::Distributed::CarProxy.instance.new
    car.should be_is_a(Car)
    car.make.should == "Toyota"
    car.respond_to?(:make).should == true
    Mack::Distributed::CarProxy.instance.buy.should == true
  end
  

end