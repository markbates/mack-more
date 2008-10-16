require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")
require 'xmpp4r-simple'

describe Mack::Notifier::DeliveryHandlers::XmppTransport do
  
  describe "deliver" do
    
    it "should send the message" do
      configatron.temp do
        configatron.mack.notifier.xmpp_settings.wait_for_response = true
        we = WelcomeEmail.new
        we.to = "h_test2@jabber80.com"
        we.from = "h_test@jabber80.com"
        we.subject = "XMPP Transport test"
        we.body(:plain, "my plain text body")
        
        # client = Jabber::Simple.new('h_test2@jabber80.com/home', 'test1234')
      
        adap = Mack::Notifier::Adapters::Xmpp.new(we)
        adap.convert
        lambda {
          Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
        }.should_not raise_error(Exception)
      end
    end
    
    it "should raise Authentication error" do
      configatron.temp do 
        configatron.mack.notifier.xmpp_settings.password = 'foo'
        we = WelcomeEmail.new
        we.to = "h_test2@jabber80.com"
        we.from = "h_test@jabber80.com"
        we.subject = "XMPP Transport test"
        we.body(:plain, "my plain text body")
        
        adap = Mack::Notifier::Adapters::Xmpp.new(we)
        adap.convert
        lambda {
          Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
        }.should raise_error(Jabber::ClientAuthenticationFailure)
      end
    end
    
    it "should raise send error" do
      we = WelcomeEmail.new
      we.to = "h_test22@jabber80.com"
      we.from = "h_test@jabber80.com"
      we.subject = "XMPP Transport test"
      we.body(:plain, "my plain text body")
      
      adap = Mack::Notifier::Adapters::Xmpp.new(we)
      adap.convert
      lambda {
        Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
      }.should raise_error(Mack::Errors::XmppUserNotOnline)
    end
    
    
    
  end
  
end