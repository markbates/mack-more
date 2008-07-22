require File.join(File.dirname(__FILE__), "..", "..", "spec_helper")

describe Mack::Mailer::Adapters::Tmail do
  
  describe "convert" do
  
    it "should convert a Mack::Mailer object to a TMail::Mail object"
    
  end
  
  describe "transformed" do
    
    it "should return the transformed Mack::Mailer object as a TMail::Mail object"
    
    it "should raise an error if convert hasn't been performed before calling transformed" do
      adap = Mack::Mailer::Adapters::Tmail.new(WelcomeEmail.new)
      lambda{adap.transformed}.should raise_error(Mack::Errors::UnconvertedMailer)
    end
    
  end
  
end