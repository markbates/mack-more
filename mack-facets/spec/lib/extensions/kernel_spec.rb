require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Kernel do
  
  describe "pp_to_s" do
    
    it "should return pp to a string" do
      pp_to_s([1, 2, :three, "four"]).should == %{[1, 2, :three, \"four\"]\n}
    end
    
  end
  
  describe "retryable" do
    
    before(:each) do
      @num_of_times_tried = 0
    end
    
    it "should return the results of the block if successful" do
      retryable do
        1
      end.should == 1
    end
    
    it "should raise an Exception if it's thrown" do
      lambda{
        retryable do
          raise Exception.new
        end
      }.should raise_error(Exception)
    end
    
    it "should only retry on an exception you tell it" do
      lambda{
        retryable(:on => NameError) do
          @num_of_times_tried += 1
          1 + nil
        end
      }.should raise_error(TypeError)
      @num_of_times_tried.should == 1
      @num_of_times_tried == 0
      lambda{
        retryable(:on => NameError, :tries => 2) do
          @num_of_times_tried += 1
          1 + FooBar
        end
      }.should raise_error(NameError)
      @num_of_times_tried.should == 3
    end
    
    it "should retry n number of times" do
      lambda{
        retryable(:on => NameError, :tries => 5) do
          @num_of_times_tried += 1
          1 + FooBar
        end
      }.should raise_error(NameError)
      @num_of_times_tried.should == 5
    end
    
  end
  
end