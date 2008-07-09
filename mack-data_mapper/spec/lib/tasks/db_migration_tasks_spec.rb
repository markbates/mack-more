require 'pathname'
require Pathname(__FILE__).dirname.expand_path.parent.parent + 'spec_helper'

describe "rake" do

  describe "db" do
  
    describe "migrate" do
    
      it "should migrate the database with the migrations in the db/migrations folder"
    
    end
  
    describe "rollback" do
    
      it "should rollback the database by a default of 1 step"
    
      it "should rollback the database by n steps if ENV['STEP'] is set" do
        pending
        "".should == "asdf"
      end
    
    end
  
    describe "version" do
    
      it "should return the current version number of the database" do
        pending
        raise "asdfasdfa"
      end
    
    end
  
  end
  
end