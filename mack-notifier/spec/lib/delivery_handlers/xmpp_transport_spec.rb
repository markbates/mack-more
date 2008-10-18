require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")
require 'xmpp4r-simple'

describe Mack::Notifier::DeliveryHandlers::XmppTransport do
  
  describe "deliver" do
    
    # it "should deliver" do
    #   we = WelcomeEmail.new
    #   we.to = "h_test2@jabber80.com"
    #   we.from = "h_test@jabber80.com"
    #   we.subject = "XMPP Transport test"
    #   we.body(:plain, "my plain text body")
    #   adap = Mack::Notifier::Adapters::Xmpp.new(we)
    #   adap.convert
    #   begin
    #     Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
    #   rescue Exception => ex
    #     puts ex
    #   end
    # end
    
    before(:each) do 
      @we = WelcomeEmail.new
      @we.to = "h_test2@jabber80.com"
      @we.from = "h_test@jabber80.com"
      @we.subject = "XMPP Transport test"
      @we.body(:plain, "my plain text body")
    end
    
    it "should send the message" do
      configatron.temp do
        configatron.mack.notifier.xmpp.wait_for_response = false
        client = Jabber::Simple.new('h_test2@jabber80.com/home', 'test1234')
      
        adap = Mack::Notifier::Adapters::Xmpp.new(@we)
        adap.convert
        lambda {
          Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
        }.should_not raise_error(Exception)
      end
    end
    
    it "should raise Authentication error" do
      configatron.temp do 
        configatron.mack.notifier.xmpp.password = 'foo'
        
        adap = Mack::Notifier::Adapters::Xmpp.new(@we)
        adap.convert
        lambda {
          Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
        }.should raise_error(Jabber::ClientAuthenticationFailure)
      end
    end
    
    it "should raise generic xmpp error" do      
      @we.to = "h_test22@jabber80.com"
      
      adap = Mack::Notifier::Adapters::Xmpp.new(@we)
      adap.convert
      lambda {
        Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
      }.should raise_error(Mack::Errors::XmppError)
    end
    
    it "should raise offline error" do
      @we.to = "h_test22@jabber80.com"
      
      adap = Mack::Notifier::Adapters::Xmpp.new(@we)
      adap.convert
      begin
        Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
      rescue Mack::Errors::XmppError => ex
        ex.get_error(:offline).should_not be_empty
      end
    end
    
    # it "should send to multiple recipients" do
    #   configatron.temp do
    #     configatron.mack.notifier.xmpp.wait_for_response = false
    #     @we.to = ["h_test2@jabber80.com", "h_test3@jabber80.com"]
    #     adap = Mack::Notifier::Adapters::Xmpp.new(@we)
    #     adap.convert
    #     lambda {
    #       Mack::Notifier::DeliveryHandlers::XmppTransport.deliver(adap)
    #     }.should_not raise_error(Exception)
    #   end
    # end
    # 
    
    
  end
  
end