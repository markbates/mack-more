require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe "Page Caching" do
  
  before(:each) do
    Cachetastic::Caches::PageCache.expire_all
  end
  
  describe "use_page_caching is turned on" do
  
    it "should serve a cached page" do
      Cachetastic::Caches::PageCache.set("/", Mack::Caching::PageCaching::Page.new("hello"))
      get "/"
      response.body.should == "hello"
      response.content_type.should == "text/html"
    end
    
    it "should cache a page designated to be cached" do
      get "/default/hello_world?name=mark"
      response.body.should match(/<p>mark<\/p>/)
      page = Cachetastic::Caches::PageCache.get("/default/hello_world?name=mark")
      page.to_s.should == response.body
      page.content_type.should == "text/html"
      get "/default/never_cached"
      response.should be_successful
      Cachetastic::Caches::PageCache.get("/default/never_cached").should be_nil
      old_body = response.body
      get "/default/never_cached"
      response.should be_successful
      response.body.should_not == old_body
    end
    
    it "should store and deliver the content type correctly" do
      get "/default/hello_world.xml?name=mark"
      response.body.should match(/<name>mark<\/name>/)
      response.content_type.should == "application/xml; text/xml"
      old_body = response.body
      get "/default/hello_world.xml?name=mark"
      response.body.should == old_body
      response.content_type.should == "application/xml; text/xml"
    end
    
    
    it "should never store non-successful pages" do
      get "/default/always_500"
      response.status.should == 500
      Cachetastic::Caches::PageCache.get("/default/always_500").should be_nil
    end
    
    
  end
  
  describe "use_page_caching is turned off" do
  
    it "should serve the uncached page" do
      temp_app_config(:mack => {:caching => {:use_page_caching => false}}) do
        get "/default/hello_world?name=mark"
        response.body.should match(/<p>mark<\/p>/)
        old_body = response.body
        get "/default/hello_world?name=mark"
        response.body.should match(/<p>mark<\/p>/)
        response.body.should_not == old_body
      end
    end
    
    it "should not store the cached page" do
      temp_app_config(:mack => {:caching => {:use_page_caching => false}}) do
        get "/default/hello_world?name=mark"
        response.body.should match(/<p>mark<\/p>/)
        Cachetastic::Caches::PageCache.get("/default/hello_world?name=mark").should be_nil
      end
    end
    
  end
  
  
end