require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe Mack::ViewHelpers::OrmHelpers do
  
  describe "error_messages_for" do
    
    before(:all) do
      User.auto_migrate!
      Person.auto_migrate!
      # ActiveRecord::Migrator.up(migrations_directory)
    end

    after(:all) do
      # ActiveRecord::Migrator.down(migrations_directory)
    end
    
    it "should default to the inline ERB template" do
      # pending
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
      # pending
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
    
    it "should allow you to pass in a partial"
    
    it "should find and use the default partial"
    
  end
  
end