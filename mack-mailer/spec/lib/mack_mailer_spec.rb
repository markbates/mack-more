require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Mack::Mailer do
  
  before(:each) do
    @we = WelcomeEmail.new
    FileUtils.rm_rf(Mack::Paths.mailers)
  end
  
  describe "date_sent" do
    
    it "should return Time.now if no date_sent is specified" do
      @we.date_sent.to_s.should == Time.now.to_s
      @we.date_sent = 1.days.ago
      @we.date_sent.to_s.should == 1.days.ago.to_s
    end
    
  end
  
  describe "content_type" do
    
    it "should return text/plain if there's only a text body" do
      @we.text_body = "hello"
      @we.content_type.should == "text/plain"
    end
    
    it "should return text/html if there's only a html body" do
      @we.html_body = "hello"
      @we.content_type.should == "text/html"
    end
    
    it "should return multipart/alternative if there's both a text and html body" do
      @we.text_body = "hello"
      @we.html_body = "hello"
      @we.content_type.should == "multipart/alternative"
    end
    
    it "should return multipart/mixed if there's an attachment"
    
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
    
    it "if no text_body it should load a *.text.erb file, if available" do
      FileUtils.mkdir_p(Mack::Paths.mailers("welcome_email"))
      text_file = Mack::Paths.mailers("welcome_email", "text.erb")
      File.open(text_file, "w") do |f|
        f.puts "Hello <%= mailer.to %>"
      end
      @we.to = "mark@mackframework.com"
      @we.text_body.should == "Hello mark@mackframework.com\n"
    end
    
  end
  
  describe "html_body" do
    
    it "if no html_body it should load a *.html.erb file, if available" do
      FileUtils.mkdir_p(Mack::Paths.mailers("welcome_email"))
      html_file = Mack::Paths.mailers("welcome_email", "html.erb")
      File.open(html_file, "w") do |f|
        f.puts "Hello <b><%= mailer.to %></b>"
      end
      @we.to = "mark@mackframework.com"
      @we.html_body.should == "Hello <b>mark@mackframework.com</b>\n"
    end
    
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
  
end