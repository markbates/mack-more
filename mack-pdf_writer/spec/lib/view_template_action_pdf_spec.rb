require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe "render(:action)" do
    
  describe "pdf" do
    
    it "should render pdf content" do
      get hello_pdf_url

      response.content_type.to_s.should == "application/pdf"
      response.body.should match(/%PDF-1.3/)
    end

  end # pdf
  
end