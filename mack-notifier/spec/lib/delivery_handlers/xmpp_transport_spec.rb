require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe Mack::Notifier::DeliveryHandlers::XmppTransport do
  
  describe "deliver" do
    
    it "should send the message" do
      we = WelcomeEmail.new
      we.to = "testuser2@lizcatering.com"
      we.from = "h_test@jabber80.com"
      we.subject = "XMPP Transport test"
      we.body(:plain, "my plain text body")
      
      adap = Mack::Notifier::Adapters::Xmpp.new(we)
      adap.convert
      Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
    end
    
  end
  
end