require File.join(File.dirname(__FILE__), "..", "..", "..", "spec_helper")

describe "Distributed Layout" do
  
  it "should alias Mack::Rendering::Type::Layout.render as local_render" do
    Mack::Rendering::Type::Layout.instance_methods.include?("local_render").should == true
  end
  
end