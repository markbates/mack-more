require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::Utils::Inflector do
  
  def inflect
    Mack::Utils::Inflector.instance
  end
  
  describe "pluralize" do
    
    it "should return the plural of a given word" do
      inflect.pluralize("error").should == "errors"
      inflect.pluralize("errors").should == "errors"
      inflect.pluralize("boats").should == "boats"
      inflect.pluralize("sheep").should == "sheep"
      inflect.pluralize("boat").should == "boats"
      inflect.pluralize("girl").should == "girls"
      inflect.pluralize("army").should == "armies"
      inflect.pluralize("person").should == "people"
      inflect.pluralize("equipment").should == "equipment"
      inflect.pluralize("stimulus").should == "stimuli"
      inflect.pluralize("quiz").should == "quizzes"
    end
    
  end
  
  describe "singularize" do
    
    it "should return the singular of a given word" do
      inflect.singularize("boat").should == "boat"
      inflect.singularize("error").should == "error"
      inflect.singularize("errors").should == "error"
      inflect.singularize("sheep").should == "sheep"
      inflect.singularize("boats").should == "boat"
      inflect.singularize("girls").should == "girl"
      inflect.singularize("armies").should == "army"
      inflect.singularize("people").should == "person"
      inflect.singularize("equipment").should == "equipment"
      inflect.singularize("quizzes").should == "quiz"
    end
    
  end
  
  describe "irregular" do
    
    it "should return the irregular version of a given word" do
      inflect.singularize("equipment").should == "equipment"
      inflect.pluralize("equipment").should == "equipment"
      inflect.singularize("knowledge").should == "knowledge"
      inflect.pluralize("knowledge").should == "knowledge"
    end
    
  end
    
end