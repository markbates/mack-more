require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")
require 'rinda/ring'
require 'rinda/tuplespace'

describe Mack::Distributed do
  
  before(:each) do
    begin
      DRb.start_service
      Rinda::RingServer.new(Rinda::TupleSpace.new)
    rescue Errno::EADDRINUSE => e
      # it's fine to ignore this, it's expected that it's already running.
      # all other exceptions should be thrown
    end
  end
  
  it "should recognize undefined constants and return it from rinda" do
    class Computer
      include Mack::Distributed::Object
      def processor
        "Intel"
      end
    end
    Mack::Distributed::Computer.should be_is_a(Mack::Distributed::ComputerProxy)
    comp = Mack::Distributed::Computer.new
    comp.processor.should == "Intel"
  end
  
  it "should recognize undefined constants and raise an error if it's not found in rinda" do
    lambda {
      Mack::Distributed::Keyboard
    }.should raise_error(Rinda::RequestExpiredError)
  end
  
  it "should raise Mack::Distributed::Errors::ApplicationNameUndefined if app_config.mack.distributed_app_name is nil" do
    temp_app_config("mack::distributed_app_name" => nil) do
      lambda {
        class Mouse
          include Mack::Distributed::Object
        end
      }.should raise_error(Mack::Distributed::Errors::ApplicationNameUndefined)
    end
  end
  
end