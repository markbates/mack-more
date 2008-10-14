require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Mack::Notifier::Validatable do
  
  class QuestionEmail
    include Mack::Notifier
    include Mack::Notifier::Validatable
    
    validates_presence_of :subject
  end
  
  class AnswerEmail
    include Mack::Notifier
    include Mack::Notifier::Validatable
    
    common_notifier_validations
  end
  
  before(:each) do
    @qe = QuestionEmail.new
    @ae = AnswerEmail.new
  end
  
  describe "form error handler" do
    include Mack::ViewHelpers
    
    it "should add extra style to form if there's an error" do
      @ae.should_not be_valid
      text_field(:ae, :to, :error_class => "my_error").should match(/class=\"my_error\"/)
    end
    
    it "should not add extra style to form if there's no error" do
      @my_qe = QuestionEmail.new
      @my_qe.subject = "hello world"
      @my_qe.should be_valid
      text_field(:my_qe, :subject, :error_class => "my_error").should_not match(/class=\"my_error\"/)
    end
    
    describe 'errors_for' do
      
      it 'should return the errors for a particular field' do
        @ae.should_not be_valid
        @ae.errors_for(:to).should include("can't be empty")
      end
      
    end
    
  end
  
  describe "common_notifier_validations" do
    
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
      include Mack::Notifier
      include Mack::Notifier::Validatable
      
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
    if RUBY_VERSION == '1.8.6'
      @qe.errors.on(:deliver).should include("mail destination not given")
    elsif RUBY_VERSION == '1.8.7'
      @qe.errors.on(:deliver).should include("could not get 3xx (554)")
    end
  end
  
  it "should not try and deliver! if the mail isn't valid" do
    @qe.errors.should be_empty
    lambda{@qe.deliver!(:smtp)}.should raise_error(RuntimeError)
  end
  
  it "should include the validatable library" do
    QuestionEmail.new.should be_is_a(::Validatable)
  end
  
end