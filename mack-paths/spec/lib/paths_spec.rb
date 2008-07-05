require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::Paths do
  
  describe "public" do
    
    it "should give the path to the public directory" do
      Mack::Paths.public.should == File.join(Mack.root, "public")
    end
    
  end
  
  describe "app" do
    
    it "should give the path to the app directory" do
      Mack::Paths.app.should == File.join(Mack.root, "app")
    end
    
  end
  
  describe "lib" do
    
    it "should give the path to the lib directory" do
      Mack::Paths.lib.should == File.join(Mack.root, "lib")
    end
    
  end
  
  describe "config" do
    
    it "should give the path to the config directory" do
      Mack::Paths.config.should == File.join(Mack.root, "config")
    end
    
  end
  
  describe "views" do
    
    it "should give the path to the views directory" do
      Mack::Paths.views.should == File.join(Mack::Paths.app, "views")
    end
    
  end
  
  describe "layouts" do
    
    it "should give the path to the layouts directory" do
      Mack::Paths.layouts.should == File.join(Mack::Paths.views, "layouts")
    end
    
  end
  
  describe "vendor" do
    
    it "should give the path to the vendor directory" do
      Mack::Paths.vendor.should == File.join(Mack.root, "vendor")
    end
    
  end
  
  describe "plugins" do
    
    it "should give the path to the plugins directory" do
      Mack::Paths.plugins.should == File.join(Mack::Paths.vendor, "plugins")
    end
    
  end
  
end