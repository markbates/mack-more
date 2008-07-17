require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Utils::Hookable do
  
  class FishCatcher
    include Singleton
    
    attr_accessor :messages
    
    def initialize
      reset!
    end
    
    def reset!
      @messages = []
    end
    
  end
  
  module Sea
    include Mack::Utils::Hookable
    class Fish
      include Mack::Utils::Hookable

      def bait
        FishCatcher.instance.messages << "baiting..."
      end

      def self.sinker
        FishCatcher.instance.messages << "sinking..."
      end

    end
    
    def self.wet?
      @is_wet
    end
  end
  
  class Norm
    include Mack::Utils::Hookable
    attr_reader :dirty
    def make_dirty
      x = yield
      @dirty = true
    end
    
    after(:make_dirty) do
      puts "@dirty: #{@dirty.inspect}"
      @dirty = false
    end
  end
  
  Sea::Fish.before(:bait) do
    FishCatcher.instance.messages << "before bait..."
  end
  
  Sea::Fish.after(:bait) do
    FishCatcher.instance.messages << "after bait..."
  end
  
  Sea::Fish.before_class_method(:sinker) do
    FishCatcher.instance.messages << "before sinker..."
  end
  
  Sea::Fish.after_class_method(:sinker) do
    FishCatcher.instance.messages << "after sinker..."
  end
  
  before(:each) do
    FishCatcher.instance.reset!
  end
  
  describe "before" do
    
    it "should prefix the given instance method with the block provided" do
      Sea::Fish.new.bait
      FishCatcher.instance.messages[0].should == "before bait..."
      FishCatcher.instance.messages[1].should == "baiting..."
    end
    
    it "should work with a method that takes a block" do
      # pending
      norm = Norm.new
      norm.make_dirty do
        "sir"
      end
      puts norm.instance_variables.inspect
      norm.dirty.should == false
    end
    
  end
  
  describe "after" do
    
    it "should append the given instance method with the block provided" do
      Sea::Fish.new.bait
      FishCatcher.instance.messages[1].should == "baiting..."
      FishCatcher.instance.messages[2].should == "after bait..."
    end
    
  end
  
  describe "before_class_method" do
    
    it "should prefix the given class method with the block provided" do
      Sea::Fish.sinker
      FishCatcher.instance.messages[0].should == "before sinker..."
      FishCatcher.instance.messages[1].should == "sinking..."
    end
    
    it "should work with modules" do
      Sea.should_not be_wet
      Sea.before_class_method(:wet?) do
        @is_wet = true
      end
      Sea.should be_wet
    end
    
  end
  
  describe "after_class_method" do
    
    it "should append the given class method with the block provided" do
      Sea::Fish.sinker
      FishCatcher.instance.messages[1].should == "sinking..."
      FishCatcher.instance.messages[2].should == "after sinker..."
    end
    
    it "should allow for raising of errors" do
      Sea.after_class_method(:wet?) do
        raise 'hell!'
      end
      lambda {Sea.wet?}.should raise_error(RuntimeError)
    end
    
  end
  
end


if $0 == __FILE__
  require 'benchmark'
  class Yummy
    include Mack::Utils::Hookable
    def save
    end
  end
  
  puts Benchmark.realtime {
    y = Yummy.new
    1.times do
      y.save
    end
  }
  
  Yummy.after(:save) do
  end
  
  puts Benchmark.realtime {
    y = Yummy.new
    1.times do
      y.save
    end
  }
  
end