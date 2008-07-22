require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe "ViewTemplate" do
    
  describe "rjs" do
    it "should handle rjs request" do
      xhr :post, bleeding_gums_murphy_url
      body = "MySaxFunc();Element.replace('my_div', 'Sax on the Beach');"
      response.body.should == body.strip
      response["Content-Type"].should == "text/javascript" 
    end
    
    it "should handle rjs request with params" do
      xhr :post, bleeding_gums_murphy_url(:bleeding => true)
      body = "MySaxFunc();Element.replace('my_div', 'Sax on the Beach');I'm Bleeding Gums!;"
      response.body.should == body.strip
      response["Content-Type"].should == "text/javascript"
    end
    
    it "should handle rjs request with render" do
      xhr :post, bleeding_gums_murphy_with_render_url
      body = "MySaxFunc();Element.replace('my_div', 'Sax on the Beach');"
      response.body.should == body.strip
      response["Content-Type"].should == "text/javascript"
    end
    
    it "should handle rjs request with render with param" do
      xhr :post, bleeding_gums_murphy_with_render_url(:bleeding => true)
      body = "MySaxFunc();Element.replace('my_div', 'Sax on the Beach');I'm Bleeding Gums!;"
      response.body.should == body.strip
      response["Content-Type"].should == "text/javascript"
    end
    
  end  
end