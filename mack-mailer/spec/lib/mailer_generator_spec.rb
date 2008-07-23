require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe MailerGenerator do
  
  before(:each) do
    FileUtils.rm_rf(Mack::Paths.mailers)
  end
  
  it "should require a name"
  
  it "should create a mailer class"
  
  it "should create text.erb and html.erb files"
  
  it "should create a spec test if using rspec"
  
  it "should create a test_case test if using test_case"
  
end