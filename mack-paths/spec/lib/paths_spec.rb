require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::Paths do
  
  describe "public" do
    
    it "should give the path to the public directory" do
      Mack::Paths.public.should == File.join(Mack.root, "public", "")
    end
    
    it "should join the file name given with the public directory path" do
      Mack::Paths.public("index.html").should == File.join(Mack.root, "public", "index.html")
    end
    
    it "should join the file names given with the public directory path" do
      Mack::Paths.public("foo", "index.html").should == File.join(Mack.root, "public", "foo", "index.html")
    end
    
  end
  
  describe "app" do
    
    it "should give the path to the app directory" do
      Mack::Paths.app.should == File.join(Mack.root, "app", "")
    end
    
  end
  
  describe "lib" do
    
    it "should give the path to the lib directory" do
      Mack::Paths.lib.should == File.join(Mack.root, "lib", "")
    end
    
  end
  
  describe "config" do
    
    it "should give the path to the config directory" do
      Mack::Paths.config.should == File.join(Mack.root, "config", "")
    end
    
  end
  
  describe "views" do
    
    it "should give the path to the views directory" do
      Mack::Paths.views.should == File.join(Mack::Paths.app, "views", "")
    end
    
  end
  
  describe "controllers" do
    
    it "should give the path to the controllers directory" do
      Mack::Paths.controllers.should == File.join(Mack::Paths.app, "controllers", "")
    end
    
  end
  
  describe "helpers" do
    
    it "should give the path to the helpers directory" do
      Mack::Paths.helpers.should == File.join(Mack::Paths.app, "helpers", "")
    end
    
  end
  
  describe "models" do
    
    it "should give the path to the models directory" do
      Mack::Paths.models.should == File.join(Mack::Paths.app, "models", "")
    end
    
  end
  
  describe "layouts" do
    
    it "should give the path to the layouts directory" do
      Mack::Paths.layouts.should == File.join(Mack::Paths.views, "layouts", "")
    end
    
  end
  
  describe "db" do
    
    it "should give the path to the db directory" do
      Mack::Paths.db.should == File.join(Mack.root, "db", "")
    end
    
  end
  
  describe "migrations" do
    
    it "should give the path to the migrations directory" do
      Mack::Paths.migrations.should == File.join(Mack::Paths.db, "migrations", "")
    end
    
  end
  
  describe "vendor" do
    
    it "should give the path to the vendor directory" do
      Mack::Paths.vendor.should == File.join(Mack.root, "vendor", "")
    end
    
  end
  
  describe "plugins" do
    
    it "should give the path to the plugins directory" do
      Mack::Paths.plugins.should == File.join(Mack::Paths.vendor, "plugins", "")
    end
    
  end
  
end