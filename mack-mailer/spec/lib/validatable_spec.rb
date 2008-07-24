require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Mack::Mailer::Validatable do
  
  class QuestionEmail
    include Mack::Mailer
    include Mack::Mailer::Validatable
    
    validates_presence_of :subject
  end
  
  before(:each) do
    @qe = QuestionEmail.new
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