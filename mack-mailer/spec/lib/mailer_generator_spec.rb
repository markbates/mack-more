require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe MailerGenerator do
  
  before(:each) do
    FileUtils.rm_rf(Mack::Paths.mailers)
    FileUtils.rm_rf(Mack::Paths.test)
    @mailer_file = Mack::Paths.mailers("registration_email.rb")
    @text_file = Mack::Paths.mailers("registration_email", "text.erb")
    @html_file = Mack::Paths.mailers("registration_email", "html.erb")
  end
  
  it "should require a name" do
    lambda{MailerGenerator.new}.should raise_error(ArgumentError)
  end
  
  it "should create a mailer class" do
    File.should_not be_exists(@mailer_file)
    MailerGenerator.run("name" => "registration_email")
    File.should be_exists(@mailer_file)
    File.read(@mailer_file).should == fixture("registration_email.rb")
  end
  
  it "should create text.erb and html.erb files" do
    File.should_not be_exists(@text_file)
    File.should_not be_exists(@html_file)
    MailerGenerator.run("name" => "registration_email")
    File.should be_exists(@text_file)
    File.read(@text_file).should == fixture("text.erb")
    File.should be_exists(@html_file)
    File.read(@html_file).should == fixture("html.erb")
  end
  
  it "should create a spec test if using rspec"
  
  it "should create a test_case test if using test_case"
  
end