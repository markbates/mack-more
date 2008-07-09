require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::OrmHelpers do
  
  describe "error_messages_for" do
    
    before(:all) do
      ActiveRecord::Migrator.up(migrations_directory)
    end

    after(:all) do
      ActiveRecord::Migrator.down(migrations_directory)
    end
    
    it "should default to the inline ERB template" do
      post users_create_url, :user => {}
      
      response.body.should == %{
<div>
  <div class="errorExplanation" id="errorExplanation">
    <h2>1 error occured.</h2>
    <ul>
        <li>User username can't be blank</li>
    </ul>
  </div>
</div>
      }
    end
    
    it "should handle multiple models" do
      post people_and_users_create_url, :user => {}, :person => {}
      
      response.body.should == %{
<div>
  <div class="errorExplanation" id="errorExplanation">
    <h2>2 errors occured.</h2>
    <ul>
        <li>User username can't be blank</li>
        <li>Person full name can't be blank</li>
    </ul>
  </div>
</div>
      }
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
  
end