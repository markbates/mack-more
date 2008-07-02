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
      
      response.body.should == %{
<div>
  <div class="errorExplanation" id="errorExplanation">
    <h2>1 error occured.</h2>
    <ul>
        <li>Username must not be blank</li>
    </ul>
  </div>
</div>
      }
    end
    
    it "should handle multiple models" do
      # pending
      post people_and_users_create_url, :user => {:id => 1}, :person => {:id => 1}
      
      response.body.should == %{
<div>
  <div class="errorExplanation" id="errorExplanation">
    <h2>2 errors occured.</h2>
    <ul>
        <li>Username must not be blank</li>
        <li>Full name must not be blank</li>
    </ul>
  </div>
</div>
      }
    end
    
    it "should allow you to pass in a partial"
    
    it "should find and use the default partial"
    
  end
  
end