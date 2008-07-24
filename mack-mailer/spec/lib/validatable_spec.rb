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