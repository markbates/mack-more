require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe Mack::Mailer::DeliveryHandlers::Smtp do
  
  describe "deliver" do
    
    it "should send the mail" do
      we = WelcomeEmail.new
      we.to = "mbates@helium.com"
      we.from = "mark@mackframework.com"
      we.subject = "smtp handler test"
      we.text_body = "my plain text body"
      we.html_body = "my <b>html</b> body"
      Mack::Mailer::DeliveryHandlers::Smtp.deliver(we)
    end
    
  end
  
end