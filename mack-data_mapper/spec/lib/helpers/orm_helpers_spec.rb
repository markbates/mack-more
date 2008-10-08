require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::DataMapperHelpers do
  include Mack::ViewHelpers
  
  describe "error_messages_for" do
    
    before(:all) do
      User.auto_migrate!
      Person.auto_migrate!
    end
    
    it "should default to the inline ERB template" do
      post users_create_url, :user => {:id => 1}
      response.body.strip.should == fixture("default_single_model_error.html.erb").strip
    end
    
    it "should handle multiple models" do
      post people_and_users_create_url, :user => {:id => 1}, :person => {:id => 1}
      response.body.strip.should == fixture("default_multiple_model_errors.html.erb").strip
    end
    
    it "should allow you to pass in a partial" do
      put users_update_url(:id => 1), :user => {:id => 1}
      response.body.strip.should == fixture("partial_single_model_error.html.erb").strip
    end
    
    it "should find and use the default partial" do
      FileUtils.rm_rf(Mack::Paths.views("application"))
      FileUtils.mkdir_p(Mack::Paths.views("application"))
      File.open(Mack::Paths.views("application", "_error_messages.html.erb"), "w") {|f| f.puts fixture("partial_single_model_error.html.erb")}
      post users_create_url, :user => {:id => 1}
      response.body.should == fixture("partial_single_model_error_with_form.html.erb")
      FileUtils.rm_rf(Mack::Paths.views("application"))
    end
    
  end
  
end