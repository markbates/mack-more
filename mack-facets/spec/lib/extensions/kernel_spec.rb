require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Kernel do
  
  describe 'alias_instance_method' do
    
    class Corn
      def poppy
        10
      end
      def corny
        'corn'
      end
    end
    
    class Popcorn < Corn
      alias_instance_method :poppy
      alias_instance_method :corny, :old_corny
      def poppy
        2 * _original_poppy
      end
      def corny
        'pop' + old_corny
      end
    end
    
    it 'should alias an instance method' do
      pc = Popcorn.new
      pc.poppy.should == 20
      pc.corny.should == 'popcorn'
    end
    
  end
  
  describe 'alias_class_method' do
    
    class President
      def self.good
        'Clinton'
      end
      def self.bad
        'Bush'
      end
    end
    
    class President
      alias_class_method :good
      alias_class_method :bad, :old_bad
      def self.good
        'Bill ' + _original_good
      end
      def self.bad
        "Either #{old_bad}"
      end
    end
    
    it 'should alias a class method' do
      President.good.should == 'Bill Clinton'
      President.bad.should == 'Either Bush'
    end
    
  end
  
  describe 'run_once' do
    
    before(:each) do
      @foo_tmp = File.join(File.dirname(__FILE__), '..', '..', 'foo.tmp')
      FileUtils.rm @foo_tmp if File.exists?(@foo_tmp)
    end
    
    after(:each) do
      FileUtils.rm @foo_tmp if File.exists?(@foo_tmp)
    end
    
    it 'should only run the code once' do
      File.should_not be_exists(@foo_tmp)
      load File.join(File.dirname(__FILE__), '..', '..', 'example.rb')
      File.should be_exists(@foo_tmp)
      FileUtils.rm @foo_tmp
      File.should_not be_exists(@foo_tmp)
      load File.join(File.dirname(__FILE__), '..', '..', 'example.rb')
      File.should_not be_exists(@foo_tmp)
    end
    
  end
  
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