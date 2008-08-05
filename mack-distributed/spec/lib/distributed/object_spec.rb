require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")
require 'rinda/ring'
require 'rinda/tuplespace'

describe Mack::Distributed::Object do

  class Car
    include Mack::Distributed::Object
  end

  it "should include DRbUndumped" do
    Car.new.should be_is_a(DRbUndumped)
  end

end