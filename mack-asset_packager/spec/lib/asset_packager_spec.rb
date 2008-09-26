require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe "Asset Packager" do
  
  describe "Configuration" do
    it "should have ASSET_LOAD_TIME defined" do
      Mack::Assets::Package.const_defined?('ASSET_LOAD_TIME').should == true
    end
    
    it "should have configatron setting" do
      configatron.mack.asset_packager.disable_bundle_merge.should_not == {}
      configatron.mack.asset_packager.disable_bundle_merge.should == false
    end
  end
  
  describe Mack::Assets::Package do
    
    before(:all) do
      assets.test_group do |a|
        a.add_css "scaffold"
        a.add_js "my_script"
      end
      
      @js_bundle = Mack::Paths.javascripts("test_group.js")
      @css_bundle = Mack::Paths.stylesheets("test_group.css")
      
      File.exists?(@js_bundle).should_not == true
      File.exists?(@css_bundle).should_not == true
    end
    
    after(:each) do
      begin
        FileUtils.rm_rf(@js_bundle)
        FileUtils.rm_rf(@css_bundle)
      rescue => ex
      end
    end
        
    it "should package and compress javascript file in production mode" do      
      old_env = Mack.env
      ENV["MACK_ENV"] = "production"
      pkg = Mack::Assets::Package.new('test_group', 'javascripts')
      contents = pkg.contents
      contents.should_not be_nil
      contents.should_not be_empty
      contents.size.should == 1
      contents[0].should == 'test_group.js'
      File.exists?(@js_bundle).should == true
      File.size(@js_bundle).should <= File.size(Mack::Paths.javascripts('my_script.js'))
      ENV["MACK_ENV"] = old_env
    end
    
    it "should not package and compress javascript file if it's disabled" do
      old_env = Mack.env
      ENV["MACK_ENV"] = "production"
      
      configatron.temp do 
        configatron.mack.asset_packager.disable_bundle_merge = true
        pkg = Mack::Assets::Package.new('test_group', 'javascripts')
        contents = pkg.contents
        contents.should_not be_nil
        contents.should_not be_empty
        contents.size.should == 1
        contents[0].should == 'test_group'
        File.exists?(@js_bundle).should_not == true
      end
      
      ENV["MACK_ENV"] = old_env
    end
    
    it "should only package and compress asset bundles" do
      old_env = Mack.env
      ENV["MACK_ENV"] = "production"
      pkg = Mack::Assets::Package.new(['test_group', 'foo', 'bar.js'], 'javascripts')
      contents = pkg.contents
      contents.should_not be_nil
      contents.should_not be_empty
      contents.size.should == 3
      contents.should == ['test_group.js', 'foo', 'bar.js']
      File.exists?(@js_bundle).should == true
      File.size(@js_bundle).should <= File.size(Mack::Paths.javascripts('my_script.js'))
      ENV["MACK_ENV"] = old_env
    end
    
    it "should also process stylesheets" do
      old_env = Mack.env
      ENV["MACK_ENV"] = "production"
      pkg = Mack::Assets::Package.new(['test_group', 'foo', 'bar.css'], 'stylesheets')
      contents = pkg.contents
      contents.should_not be_nil
      contents.should_not be_empty
      contents.size.should == 3
      contents.should == ['test_group.css', 'foo', 'bar.css']
      File.exists?(@css_bundle).should == true
      File.size(@css_bundle).should <= File.size(Mack::Paths.stylesheets('scaffold.css'))
      ENV["MACK_ENV"] = old_env
    end
  end
  
  describe 'LinkHelpers Extension' do
    include Mack::ViewHelpers::LinkHelpers
    
    before(:all) do
      assets.test_group do |a|
        a.add_css "scaffold"
        a.add_js "my_script"
      end
      
      @js_bundle = Mack::Paths.javascripts("test_group.js")
      @css_bundle = Mack::Paths.stylesheets("test_group.css")
      
      File.exists?(@js_bundle).should_not == true
      File.exists?(@css_bundle).should_not == true
    end
    
    after(:each) do
      begin
        FileUtils.rm_rf(@js_bundle)
        FileUtils.rm_rf(@css_bundle)
      rescue => ex
      end
    end
    
    describe "javascript" do
      before(:each) do
        @old_env = Mack.env
        ENV["MACK_ENV"] = "production"
      end
      after(:each) do
        ENV["MACK_ENV"] = @old_env
      end
      
      it "should return proper tag" do
        javascript(:test_group).starts_with?(%{<script src="/javascripts/test_group.js?}).should == true
      end
      
      it "should handle non-bundle tag properly" do
        data = javascript([:test_group, :foo, :bar])
        exp  = [%{<script src="/javascripts/test_group.js?},
                %{<script src="/javascripts/foo.js?},
                %{<script src="/javascripts/bar.js?}]
        exp.each do |line|
          data.should match(line)
        end
      end
      
      it "should expand the bundle if compression is disabled" do
        configatron.temp do 
          configatron.mack.asset_packager.disable_bundle_merge = true
          data = javascript([:test_group, :foo, :bar])
          exp  = [%{<script src="/javascripts/my_script.js?},
                  %{<script src="/javascripts/foo.js?},
                  %{<script src="/javascripts/bar.js?}]
          exp.each do |line|
            data.should match(line)
          end          
        end
      end
    end 
    
    describe "stylesheets" do
      before(:each) do
        @old_env = Mack.env
        ENV["MACK_ENV"] = "production"
      end
      after(:each) do
        ENV["MACK_ENV"] = @old_env
      end
      
      it "should return proper tag" do
        stylesheet(:test_group).should match(%{<link href="/stylesheets/test_group.css})
      end
      
      it "should handle non-bundle tag properly" do
        data = stylesheet([:test_group, :foo, :bar])
        exp  = [%{<link href="/stylesheets/test_group.css"},
                %{<link href="/stylesheets/foo.css"},
                %{<link href="/stylesheets/bar.css"}]
        exp.each do |line|
          data.should match(line)
        end          
      end
      
      it "should expand the bundle if compression is disabled" do
        configatron.temp do 
          configatron.mack.asset_packager.disable_bundle_merge = true
          data = stylesheet([:test_group, :foo, :bar])
          exp  = [%{<link href="/stylesheets/scaffold.css"},
                  %{<link href="/stylesheets/foo.css"},
                  %{<link href="/stylesheets/bar.css"}]
          exp.each do |line|
            data.should match(line)
          end          
        end
      end
    end
  end  
end