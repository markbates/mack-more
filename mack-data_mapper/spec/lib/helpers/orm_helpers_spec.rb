require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::OrmHelpers do
  
  describe "error_messages_for" do
    
    before(:all) do
      User.auto_migrate!
      Person.auto_migrate!
    end

    after(:all) do
    end
    
    it "should default to the inline ERB template" do
      # pending
      post users_create_url, :user => {:id => 1}
      
      response.body.should == fixture("default_single_model_error.html.erb")
    end
    
    it "should handle multiple models" do
      # pending
      post people_and_users_create_url, :user => {:id => 1}, :person => {:id => 1}
      
      response.body.should == fixture("default_multiple_model_errors.html.erb")
    end
    
    it "should allow you to pass in a partial" do
      put users_update_url(:id => 1), :user => {:id => 1}
      response.body.should == fixture("partial_single_model_error.html.erb")
    end
    
    it "should find and use the default partial"
    
  end
  
end