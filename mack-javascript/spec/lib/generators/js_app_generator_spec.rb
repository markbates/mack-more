require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe JavascriptGenerator do
  it "should not run if there's no js_framework setting in configatron" do
    temp_app_config(:mack => {:js_framework => nil}) do
      lambda{JavascriptGenerator.new}.should raise_error(RuntimeError)
    end
  end
  
  describe "prototype" do
    before(:all) do
      @js_path = Mack::Paths.public("javascripts")
      FileUtils.rm_rf(@js_path)
    end
    
    after(:all) do 
      FileUtils.rm_rf(@js_path)
    end
    
    it "should generate prototype's .js files in public/javascripts" do
      File.exists?(@js_path).should_not == true
      JavascriptGenerator.run
      
      File.exists?(File.join(@js_path, "dragdrop.js")).should == true
      File.exists?(File.join(@js_path, "effects.js")).should == true
      File.exists?(File.join(@js_path, "controls.js")).should == true
      File.exists?(File.join(@js_path, "prototype.js")).should == true
    end
  end
  
  describe "jquery" do
    before(:all) do
      @js_path = Mack::Paths.public("javascripts")
      FileUtils.rm_rf(@js_path)
    end
    
    after(:all) do 
      FileUtils.rm_rf(@js_path)
    end

    it "should generate jquery's .js files in public/javascripts" do
      temp_app_config(:mack => {:js_framework => "jquery"}) do
        File.exists?(@js_path).should_not == true
        JavascriptGenerator.run
        
        File.exists?(File.join(@js_path, "jquery-ui.js")).should == true
        File.exists?(File.join(@js_path, "jquery-fx.js")).should == true
        File.exists?(File.join(@js_path, "jquery.js")).should == true
      end
    end
  end
  
end