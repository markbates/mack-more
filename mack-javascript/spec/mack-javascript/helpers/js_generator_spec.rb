require File.join(File.dirname(__FILE__), "..", "..", "spec_helper.rb")

describe Mack::JavaScript::ScriptGenerator do
  before(:each) do
    @p = Mack::JavaScript::ScriptGenerator.new
  end

  it "should respond to 'alert'" do
    @p.alert('look out!')
    @p.to_s.should == "alert('look out!');"
  end

  it "should respond to 'assign" do
    @p.assign('this', 'that')
    @p.to_s.should == "this = \"that\";"

    @p = Mack::JavaScript::ScriptGenerator.new
    @p.assign('this', 5)
    @p.to_s.should == "this = 5;"

    @p = Mack::JavaScript::ScriptGenerator.new
    @p.assign('this', {:my => 'hash'})
    @p.to_s.should == "this = {\"my\":\"hash\"};"

    @p = Mack::JavaScript::ScriptGenerator.new
    @p.assign('this', ['array', 1])
    @p.to_s.should == "this = [\"array\",1];"
  end

  it "should respond to 'delay'" do
    @p.delay(2) do |page|
      page.alert("wait...look out!")
    end
    @p.to_s.should == "setTimeout(function(){alert('wait...look out!');}, 2000);" 
  end

  it "should respond to 'call'" do
    @p.call('myFunc', 'firstParam', 3)
    @p.to_s.should == %{myFunc("firstParam",3);}

    @p = Mack::JavaScript::ScriptGenerator.new
    @p.call('myFunc', {:stuff => 3})
    @p.to_s.should == %{myFunc({"stuff":3});}
  end

  
  it "should generate function" do
    func = @p.function.body {|page| page.alert('my_func')}
    func.should == "function(){alert('my_func');}"
    
    func = @p.function << 'pureJs()'
    func.should == "function(){pureJs();}"
    
    func = @p.function('elem', 'other_elem')  << 'pureJs(elem, other_elem)'
    func.should == "function(elem, other_elem){pureJs(elem, other_elem);}"
    
    func = @p.function(3)  << 'pureJs(obj1, obj2, obj3)'
    func.should == "function(obj1, obj2, obj3){pureJs(obj1, obj2, obj3);}"
  end
end