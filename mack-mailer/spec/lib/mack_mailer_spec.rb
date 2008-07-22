require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Mack::Mailer do
  
  before(:each) do
    @we = WelcomeEmail.new
  end
  
  describe "destinations" do
    
    it "should concat all recipients into an array" do
      @we.to = "mark@mackframework.com"
      @we.cc = ["foo@example.com", "bar@example.com"]
      @we.bcc = "fubar@example.com"
      @we.destinations.should == ["mark@mackframework.com", "foo@example.com", "bar@example.com", "fubar@example.com"]
    end
    
  end
  
  describe "reply_to" do
    
    it "should use 'from' if no reply_to is specified" do
      @we.from = "Mark Bates"
      @we.reply_to.should == @we.from
      @we.reply_to = "mark@mackframework.com"
      @we.reply_to.should_not == @we.from
      @we.reply_to.should == "mark@mackframework.com"
    end
    
  end
  
  describe "text_body" do
    
    it "should set the text body of the email"
    
    it "if no text_body it should load a *.text.erb file, if available"
    
  end
  
  describe "html_body" do
    
    it "should set the html body of the email"
    
    it "if no html_body it should load a *.text.erb file, if available"
    
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
    
    it "should deliver the email via 'test' if configured"
    
    it "should deliver the email as multipart if both text and html are specified"
    
    it "should deliver the email as multipart if there is an attachment"
    
  end
  
  describe "deliverable" do
    
    it "should convert the message to TMail format and return a 'transport' ready object."
    
  end
  
end