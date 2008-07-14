require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::OrmHelpers do
  include Mack::ViewHelpers::OrmHelpers
  describe "error_messages_for" do
    
    before(:all) do
      User.auto_migrate!
      Person.auto_migrate!
    end
    
    it "should default to the inline ERB template" do
      post users_create_url, :user => {:id => 1}
      response.body.should == fixture("default_single_model_error.html.erb")
    end
    
    it "should handle multiple models" do
      post people_and_users_create_url, :user => {:id => 1}, :person => {:id => 1}
      response.body.should == fixture("default_multiple_model_errors.html.erb")
    end
    
    it "should allow you to pass in a partial" do
      put users_update_url(:id => 1), :user => {:id => 1}
      response.body.should == fixture("partial_single_model_error.html.erb")
    end
    
    it "should find and use the default partial" do
      FileUtils.rm_rf(Mack::Paths.views("application"))
      FileUtils.mkdir_p(Mack::Paths.views("application"))
      File.open(Mack::Paths.views("application", "_error_messages.html.erb"), "w") {|f| f.puts fixture("partial_single_model_error.html.erb")}
      post users_create_url, :user => {:id => 1}
      response.body.should == fixture("partial_single_model_error.html.erb")
      FileUtils.rm_rf(Mack::Paths.views("application"))
    end
    
  end
  
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
      response.body.should == %{<textarea id="user_username" name="user[username]">markbates</textarea>}
    end
    
  end
  
end