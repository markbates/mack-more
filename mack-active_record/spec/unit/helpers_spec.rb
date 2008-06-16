require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::ViewHelpers::OrmHelpers do
  
  before do
    write_database_yml
    Mack::Database.establish_connection
    class User < ActiveRecord::Base
      validates_presence_of :username
    end
    class Person < ActiveRecord::Base
      validates_presence_of :full_name
    end
    class CreateOrmHelpersModels < ActiveRecord::Migration
      def self.up
        create_table :users do |t|
          t.column :username, :string
        end
        create_table :people do |t|
          t.column :full_name, :string
        end
      end
      def self.down
        drop_table :users
        drop_table :people
      end
    end
    CreateOrmHelpersModels.up
  end
  
  after do
    CreateOrmHelpersModels.down
  end
  
  describe "error_messages_for" do
    
    before :each do
      @user = nil
      @person = nil
    end
    
    it "should default to the inline ERB template" do
      @user = User.new
      @user.save.should == false
      error_messages_for(:user).should == %{
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
      @user = User.new
      @person = Person.new
      @user.save.should == false
      @person.save.should == false
      error_messages_for([:user, :person]).should == %{
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
    
  end
  
end