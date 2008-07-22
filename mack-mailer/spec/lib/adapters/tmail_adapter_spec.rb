require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe Mack::Mailer::Adapters::Tmail do
  
  describe "convert" do
  
    it "should convert a Mack::Mailer object to a TMail::Mail object" do
      we = WelcomeEmail.new
      we.to = "mark@mackframework.com"
      we.from = "Mark Bates <mark@mackframework.com>"
      we.subject = "Hello World!"
      we.text_body = "This is my plain text body"
      we.html_body = "This is my <b>html</b> body"
      adap = Mack::Mailer::Adapters::Tmail.new(we)
      adap.convert
      tmail = adap.transformed
      tmail.to.should == [we.to]
    end
    
    it "should handle Array based destination fields" do
      we = WelcomeEmail.new
      we.to = ["1@1.com", "2@2.com"]
      we.cc = "3@3.com"
      we.bcc = ["4@4.com", "5@5.com"]
      adap = Mack::Mailer::Adapters::Tmail.new(we)
      adap.convert
      tmail = adap.transformed
      tmail.to.should == we.to
      tmail.cc.should == [we.cc]
      tmail.bcc.should == we.bcc
    end
    
  end
  
  describe "transformed" do
    
    it "should return the transformed Mack::Mailer object as a TMail::Mail object"
    
    it "should raise an error if convert hasn't been performed before calling transformed" do
      adap = Mack::Mailer::Adapters::Tmail.new(WelcomeEmail.new)
      lambda{adap.transformed}.should raise_error(Mack::Errors::UnconvertedMailer)
    end
    
  end
  
end