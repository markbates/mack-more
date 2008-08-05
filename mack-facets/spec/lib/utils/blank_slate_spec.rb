require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'


describe Mack::Utils::BlankSlate do
  
  class NoBrain < Mack::Utils::BlankSlate
  end
  
  it "should not have a bunch of standard methods" do
    dumb = NoBrain.new
    lambda {
      dumb.object_id
      dumb.respond_to?(:foo)
      dumb.methods
    }.should raise_error(NoMethodError)
  end
  
end