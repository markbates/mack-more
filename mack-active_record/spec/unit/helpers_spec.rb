require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent + 'spec_helper'

describe Mack::ViewHelpers::OrmHelpers do
  
  before do
    write_database_yml
    Mack::Database.establish_connection
    class User < ActiveRecord::Base
      validates_presence_of :username
    end
    class CreateUser < ActiveRecord::Migration
      def self.up
        create_table :users do |t|
          t.column :username, :string
        end
      end
      def self.down
        drop_table :users
      end
    end
    CreateUser.up
  end
  
  after do
    CreateUser.down
  end
  
  describe "error_messages_for" do
    
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
    
  end
  
end