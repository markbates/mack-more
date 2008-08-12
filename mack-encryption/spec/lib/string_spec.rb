require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe String do
  
  describe "Encryption Engine" do
    
    it "should be able to encrypt/decrypt string" do
      raw_value = "hello world"
      encrypted_value = raw_value.encrypt
      encrypted_value.should_not == raw_value
      raw_value.should == encrypted_value.decrypt
    end
    
  end
  
end