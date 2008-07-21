require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

class Mack::Javascript::Framework::FirstFramework
  class << self
    def replace
      "I'm in Framework 1"
    end
  end
end

class Mack::Javascript::Framework::SecondFramework
  class << self
    def replace
      "I'm in Framework 2"
    end
  end
end

describe Mack::Javascript::ScriptGenerator do
  before(:each) do
    @p = Mack::Javascript::ScriptGenerator.new
  end

  it "should respond to 'framework'" do
    Mack::Javascript::ScriptGenerator.framework = 'first_framework'
    Mack::Javascript::ScriptGenerator.framework.should == Mack::Javascript::Framework::FirstFramework

    Mack::Javascript::ScriptGenerator.framework = 'second_framework'
    Mack::Javascript::ScriptGenerator.framework.should == Mack::Javascript::Framework::SecondFramework
  end

  it "should respond to 'alert'" do
    @p.alert('look out!')
    @p.to_s.should == "alert('look out!');"
  end

  it "should respond to 'assign" do
    @p.assign('this', 'that')
    @p.to_s.should == "this = \"that\";"

    @p = Mack::Javascript::ScriptGenerator.new
    @p.assign('this', 5)
    @p.to_s.should == "this = 5;"

    @p = Mack::Javascript::ScriptGenerator.new
    @p.assign('this', {:my => 'hash'})
    @p.to_s.should == "this = {\"my\":\"hash\"};"

    @p = Mack::Javascript::ScriptGenerator.new
    @p.assign('this', ['array', 1])
    @p.to_s.should == "this = [\"array\",1];"
  end

  it "should respond to 'delay'" do
    del = @p.delay(2) do |page|
      page.alert("wait...look out!")
    end
    del.should == "setTimeout(function() {\n\nalert('wait...look out!');}, 2000);" 
  end

  it "should respond to 'call'" do
    @p.call('myFunc', 'firstParam', 3)
    @p.to_s.should == %{myFunc("firstParam",3);}

    @p = Mack::Javascript::ScriptGenerator.new
    @p.call('myFunc', {:stuff => 3})
    @p.to_s.should == %{myFunc({"stuff":3});}
  end

  it "should properly handle method_missing" do
    Mack::Javascript::ScriptGenerator.framework = 'first_framework'
    @p.replace.should == "I'm in Framework 1;"

    @p = Mack::Javascript::ScriptGenerator.new
    Mack::Javascript::ScriptGenerator.framework = 'second_framework'
    @p.replace.should == "I'm in Framework 2;"
  end
end
