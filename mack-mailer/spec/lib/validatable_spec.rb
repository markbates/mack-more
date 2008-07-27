require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Mack::Mailer::Validatable do
  
  class QuestionEmail
    include Mack::Mailer
    include Mack::Mailer::Validatable
    
    validates_presence_of :subject
  end
  
  class AnswerEmail
    include Mack::Mailer
    include Mack::Mailer::Validatable
    
    common_mailer_validations
  end
  
  before(:each) do
    @qe = QuestionEmail.new
    @ae = AnswerEmail.new
  end
  
  describe "common_mailer_validations" do
    
    it "should validates_presence_of :to, :from, :subject" do
      @ae.should_not be_valid
      @ae.errors.on(:to).should include("can't be empty")
      @ae.errors.on(:from).should include("can't be empty")
      @ae.errors.on(:subject).should include("can't be empty")
    end
    
    it "should validates_email_format_of of :to, :from" do
      @ae.to = "foo-bar.com"
      @ae.from = ["me-bar.com", "you-bar.com"]
      @ae.should_not be_valid
      @ae.errors.on(:to).should include("[foo-bar.com] is not valid")
      @ae.errors.on(:from).should include("[me-bar.com] is not valid")
      @ae.errors.on(:from).should include("[you-bar.com] is not valid")
    end
    
  end
  
  describe "validates_email_format_of" do
    
    class HelpEmail
      include Mack::Mailer
      include Mack::Mailer::Validatable
      
      validates_email_format_of :to
      
    end
    
    it "should validate that email address is the proper format" do
      he = HelpEmail.new
      he.to = "lksadjflsdjf"
      he.should_not be_valid
      he.errors.on(:to).should == "[lksadjflsdjf] is not valid"
      he.to = "mark@mackframework.com"
      he.should be_valid
    end
    
    it "should validate that email address is the proper format in an array" do
      he = HelpEmail.new
      he.to = ["lksadjflsdjf", "skjfkljsdlj"]
      he.should_not be_valid
      he.errors.on(:to).should == ["[lksadjflsdjf] is not valid", "[skjfkljsdlj] is not valid"]
      he.to = ["MARK@mackframework.com", "testing@mackframework.com"]
      he.should be_valid
    end
    
  end
  
  it "should add any exceptions on deliver to the errors array" do
    @qe.errors.should be_empty
    @qe.subject = "hello world"
    @qe.deliver(:smtp).should == false
    @qe.errors.should_not be_empty
    @qe.errors.size.should == 1
    @qe.errors.on(:deliver).should include("mail destination not given")
  end
  
  it "should not try and deliver! if the mail isn't valid" do
    @qe.errors.should be_empty
    lambda{@qe.deliver!(:smtp)}.should raise_error(RuntimeError)
  end
  
  it "should include the validatable library" do
    QuestionEmail.new.should be_is_a(::Validatable)
  end
  
end