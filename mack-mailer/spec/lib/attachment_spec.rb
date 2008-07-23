require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Mack::Mailer::Attachment do
  
  before(:all) do
    @my_file = File.join(File.dirname(__FILE__), "..", "fixtures", "mark-simpson.png")
  end
  
  describe "add_file" do
    
    it "should read in a file and set the content_type based on the extension"
    
  end
  
  describe "add_io" do
    
    it "should read in the IO object"
    
  end
  
  describe "new" do
    
    it "should take a string and read call add_file" do
      at = Mack::Mailer::Attachment.new(@my_file)
      at.content_type.should == "image/png"
      at.body.should == File.read(@my_file)
    end
    
    it "should take an IO and call add_io"
    
  end
  
end