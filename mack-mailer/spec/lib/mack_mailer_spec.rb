require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Mack::Mailer do
  
  describe "text_body" do
    
    it "should set the text body of the email"
    
  end
  
  describe "html_body" do
    
    it "should set the html body of the email"
    
  end
  
  describe "attach" do
    
    it "should attach a file to the email with a file path"
    
    it "should attach a file to the email with an IO object"
    
  end
  
  describe "has_attachments?" do
    
    it "should return true if there are attachments"
    
    it "should return false if there aren't attachments"
    
  end
  
  describe "attachments" do
    
    it "should return any attachments"
    
  end
  
  describe "deliver" do
    
    it "should deliver the email via SMTP if configured"
    
    it "should deliver the email via sendmail if configured"
    
    it "should deliver "
    
  end
  
end