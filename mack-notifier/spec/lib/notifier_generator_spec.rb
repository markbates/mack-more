require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe NotifierGenerator do
  
  before(:each) do
    FileUtils.rm_rf(Mack::Paths.notifiers)
    FileUtils.rm_rf(Mack::Paths.test)
    @notifier_file = Mack::Paths.notifiers("registration_email.rb")
    @text_file = Mack::Paths.notifiers("templates", "registration_email", "plain.erb")
    @html_file = Mack::Paths.notifiers("templates", "registration_email", "html.erb")
    @spec_file = Mack::Paths.notifier_tests("registration_email_spec.rb")
    @test_case_file = Mack::Paths.notifier_tests("registration_email_test.rb")
  end
  
  after(:each) do
    FileUtils.rm_rf(Mack::Paths.notifiers)
    FileUtils.rm_rf(Mack::Paths.test)
  end
  
  it "should require a name" do
    lambda{NotifierGenerator.new}.should raise_error(ArgumentError)
  end
  
  it "should create a notifier class" do
    File.should_not be_exists(@notifier_file)
    NotifierGenerator.run("name" => "registration_email")
    File.should be_exists(@notifier_file)
    File.read(@notifier_file).should == fixture("registration_email.rb")
  end
  
  it "should create plain.erb and html.erb files" do
    File.should_not be_exists(@text_file)
    File.should_not be_exists(@html_file)
    NotifierGenerator.run("name" => "registration_email")
    File.should be_exists(@text_file)
    File.read(@text_file).should == fixture("plain.erb")
    File.should be_exists(@html_file)
    File.read(@html_file).should == fixture("html.erb")
  end
  
  it "should create a spec test if using rspec" do
    temp_app_config(:mack => {:testing_framework => "rspec"}) do
      File.should_not be_exists(@spec_file)
      NotifierGenerator.run("name" => "registration_email")
      File.should be_exists(@spec_file)
      File.read(@spec_file).should == fixture("rspec.rb")
    end
  end
  
  it "should create a test_case test if using test_case" do
    temp_app_config(:mack => {:testing_framework => "test_case"}) do
      File.should_not be_exists(@test_case_file)
      NotifierGenerator.run("name" => "registration_email")
      File.should be_exists(@test_case_file)
      File.read(@test_case_file).should == fixture("test_case.rb")
    end
  end
  
end