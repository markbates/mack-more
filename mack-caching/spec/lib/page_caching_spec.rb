require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe "Page Caching" do
  
  before(:each) do
    Cachetastic::Caches::PageCache.expire_all
  end
  
  describe "use_page_caching is turned on" do
  
    it "should serve a cached page" do
      temp_app_config(:use_page_caching => true) do
        Cachetastic::Caches::PageCache.set("/", Mack::Caching::PageCaching::Page.new("hello"))
        get "/"
        response.body.should == "hello"
      end
    end
    
    it "should cache a page designated to be cached" do
      temp_app_config(:use_page_caching => true) do
        get "/"
        response.body.should match(/Welcome to your Mack application!/)
        Cachetastic::Caches::PageCache.get("/").to_s.should == response.body
      end
    end
    
    it "should store the content type correctly"
    
    it "should deliver the content type correctly"
    
    it "should store the status correctly"
    
    it "should deliver the status correctly"
    
  end
  
  describe "use_page_caching is turned off" do
  
    it "should serve the uncached page" do
      get "/"
      response.body.should match(/Welcome to your Mack application!/)
    end
    
    it "should not store the cached page"
    
  end
  
  
end