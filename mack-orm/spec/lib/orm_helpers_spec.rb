require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Mack::ViewHelpers::OrmHelpers do
  include Mack::ViewHelpers
  
  describe "model_text_field" do
    
    it "should generate a model_text_field tag for the model's property" do
      get model_text_field_test_url
      response.body.should == %{<input id="user_username" name="user[username]" type="text" value="markbates" />}
    end
    
  end
  
  describe "model_password_field" do
    
    it "should generate a model_password_field tag for the model's property" do
      get model_password_field_test_url
      response.body.should == %{<input id="user_username" name="user[username]" type="password" value="markbates" />}
    end
    
  end
  
  describe "model_textarea" do
    
    it "should generate a textarea tag" do
      get model_textarea_test_url
      response.body.should == %{<textarea cols="60" id="user_username" name="user[username]" rows="20">markbates</textarea>}
    end
    
  end
  
end