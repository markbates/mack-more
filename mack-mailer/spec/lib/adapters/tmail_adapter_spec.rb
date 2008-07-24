require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe Mack::Mailer::Adapters::Tmail do
  
  describe "convert" do
  
    it "should convert a Mack::Mailer object to a TMail::Mail object" do
      we = WelcomeEmail.new
      we.to = "test@mackframework.com"
      we.from = "mark@mackframework.com"
      we.reply_to = "mark@mackframework.com"
      we.subject = "Hello World!"
      we.text_body = "This is my plain text body"
      we.html_body = "This is my <b>html</b> body"
      adap = Mack::Mailer::Adapters::Tmail.new(we)
      adap.convert
      tmail = adap.transformed
      tmail.to.should == [we.to]
      tmail.from.should == [we.from]
      tmail.reply_to.should == [we.reply_to]
      tmail.subject.should == we.subject
      tmail.content_type.should == "multipart/alternative"
      tmail.mime_version.should == "1.0"
    end
    
    it "should handle attachments" do
      we = WelcomeEmail.new
      we.to = "mbates@helium.com"
      we.from = "mark@mackframework.com"
      we.reply_to = "mark@mackframework.com"
      we.subject = "Hello World!"
      we.text_body = "This is my plain text body"
      we.html_body = "This is my <b>html</b> body"
      we.attach(Mack::Mailer::Attachment.new(File.join(File.dirname(__FILE__), "..", "..", "fixtures", "mark-simpson.png")))
      adap = Mack::Mailer::Adapters::Tmail.new(we)
      adap.convert
      tmail = adap.transformed
      tmail.content_type.should == "multipart/mixed"
      tmail.parts[0].content_type.should == "multipart/alternative"
      text_part = tmail.parts[0].parts[0]
      text_part.content_type.should == "text/plain"
      text_part.body.should == we.text_body
      html_part = tmail.parts[0].parts[1]
      html_part.content_type.should == "text/html"
      html_part.body.should == we.html_body
      attachment_part = tmail.parts[1]
      attachment_part.content_type.should == "application/octet-stream"
      attachment_part['Content-Disposition'].to_s.should == "attachment; filename=mark-simpson.png"
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
    
    it "should return the transformed Mack::Mailer object as a TMail::Mail object" do
      we = WelcomeEmail.new
      adap = Mack::Mailer::Adapters::Tmail.new(we)
      adap.convert
      adap.transformed.should be_is_a(TMail::Mail)
    end
    
    it "should raise an error if convert hasn't been performed before calling transformed" do
      adap = Mack::Mailer::Adapters::Tmail.new(WelcomeEmail.new)
      lambda{adap.transformed}.should raise_error(Mack::Errors::UnconvertedMailer)
    end
    
  end
  
end