require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe Mack::Notifier::DeliveryHandlers::XmppTransport do
  
  describe "deliver" do
    
    it "should send the message" do
      configatron.temp do
        configatron.mack.notifier.xmpp_settings.wait_for_response = false
        we = WelcomeEmail.new
        we.to = "testuser2@lizcatering.com"
        we.from = "h_test@jabber80.com"
        we.subject = "XMPP Transport test"
        we.body(:plain, "my plain text body")
      
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
        we.to = "testuser2@lizcatering.com"
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
      we.to = "testuser22@lizcatering.com"
      we.from = "h_test@jabber80.com"
      we.subject = "XMPP Transport test"
      we.body(:plain, "my plain text body")
      
      adap = Mack::Notifier::Adapters::Xmpp.new(we)
      adap.convert
      lambda {
        Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
      }.should raise_error(Mack::Errors::XmppSendError)
      
      begin 
        Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
      rescue Mack::Errors::XmppSendError => ex
        ex.code.value.should == '404'
      end
    end
    
    
    
  end
  
end