require File.join(File.dirname(__FILE__), "..", "spec_helper.rb")

describe "Asset Packager" do
  include Mack::ViewHelpers
  
  def cleanup_bundle_files
    Mack::Assets::PackageCollection.instance.destroy_compressed_bundles
  end
  
  describe "Configuration" do
    it "should have configatron setting" do
      configatron.mack.assets.enable_bundle_merge.should_not == {}
      configatron.mack.assets.enable_bundle_merge.should == false
    end
  end
  
  describe "Package collection" do
    before(:all) do
      cleanup_bundle_files
    end
    
    after(:all) do 
      cleanup_bundle_files
      assets_mgr.groups_by_asset_type(:javascripts).each do |group|
        path = Mack::Paths.javascripts(group + ".js")
        File.exists?(path).should_not == true
      end
      assets_mgr.groups_by_asset_type(:stylesheets).each do |group|
        path = Mack::Paths.stylesheets(group + ".css")
        File.exists?(path).should_not == true
      end
    end
    
    it "should generate compressed file if config is turned on, but should not recompress in subsequent calls" do
      configatron.mack.assets.enable_bundle_merge = true
      
      Mack::Assets::PackageCollection.instance.compress_bundles
      js_times = {}
      css_times = {}
      assets_mgr.groups_by_asset_type(:javascripts).each do |group|
        path = Mack::Paths.javascripts(group + ".js")
        js_times[path] = File.ctime(path)
      end
      assets_mgr.groups_by_asset_type(:stylesheets).each do |group|
        path = Mack::Paths.stylesheets(group + ".css")
        css_times[path] = File.ctime(path)
      end
      
      # call the compress 100 times
      1000.times { |x| Mack::Assets::PackageCollection.instance.compress_bundles }
      
      # the ctime for each compressed file should not change
      assets_mgr.groups_by_asset_type(:javascripts).each do |group|
        path = Mack::Paths.javascripts(group + ".js")
        File.ctime(path).should == js_times[path]
      end
      assets_mgr.groups_by_asset_type(:stylesheets).each do |group|
        path = Mack::Paths.stylesheets(group + ".css")
        File.ctime(path).should == css_times[path]
      end

      configatron.mack.assets.enable_bundle_merge = false
    end
    
  end
  
  describe 'LinkHelpers Extension' do
    include Mack::ViewHelpers::LinkHelpers
    
    before(:all) do
      assets_mgr.test_group do |a|
        a.add_css "scaffold"
        a.add_js "my_script"
      end
      
      @js_bundle = Mack::Paths.javascripts("test_group.js")
      @css_bundle = Mack::Paths.stylesheets("test_group.css")
      
      File.exists?(@js_bundle).should_not == true
      File.exists?(@css_bundle).should_not == true
    end
    
    after(:each) do
      cleanup_bundle_files
    end
    
    describe "javascript" do
      before(:each) do
        configatron.mack.assets.enable_bundle_merge = true
      end
      after(:each) do
        configatron.mack.assets.enable_bundle_merge = false
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
          configatron.mack.assets.enable_bundle_merge = false
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
        configatron.mack.assets.enable_bundle_merge = true
      end
      after(:each) do
        configatron.mack.assets.enable_bundle_merge = false
      end
      
      it "should return proper tag" do
        stylesheet(:test_group).should match(%{<link href="/stylesheets/test_group.css})
      end
      
      it "should handle non-bundle tag properly" do
        data = stylesheet([:test_group, :foo, :bar])
        exp  = [%{<link href="/stylesheets/test_group.css},
                %{<link href="/stylesheets/foo.css},
                %{<link href="/stylesheets/bar.css}]
        exp.each do |line|
          data.should match(line)
        end          
      end
      
      it "should expand the bundle if compression is disabled" do
        configatron.temp do 
          configatron.mack.assets.enable_bundle_merge = false
          data = stylesheet([:test_group, :foo, :bar])
          exp  = [%{<link href="/stylesheets/scaffold.css},
                  %{<link href="/stylesheets/foo.css},
                  %{<link href="/stylesheets/bar.css}]
          exp.each do |line|
            data.should match(line)
          end          
        end
      end
    end
  end  
end